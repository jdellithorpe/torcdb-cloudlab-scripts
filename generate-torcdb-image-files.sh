#!/bin/bash

if [[ $# != 6 ]]
then
  echo "Take LDBC SNB dataset files that have already been partitioned "
  echo "entity-wise into N partitions and distribute those files across a "
  echo "cluster of N machines and convert the dataset into TorcDB images, "
  echo "divided into N tablets, and copy the files back to a CloudLab dataset."
  echo ""
  echo "Usage: generate-torcdb-image-files.sh DATASET_DIR SERVER_LIST REMOTE_DIR GRAPH_NAME RAMCLOUD_UTILS CL_DATASET_DIR"
  echo "  DATASET_DIR     LDBC SNB dataset directory containing "
  echo "                  social_network/ and "
  echo "                  social_network_supplementary_files/ directories "
  echo "                  divided into N partitions. N is detected "
  echo "                  automatically from the dataset files."
  echo "  SERVER_LIST     List of hostnames of the servers to copy the "
  echo "                  dataset to, one per line. If there are more than N "
  echo "                  servers, will use the first N."
  echo "  REMOTE_DIR      Local disk directory on remote host to copy files "
  echo "                  to."
  echo "  GRAPH_NAME      Name of the graph."
  echo "  RAMCLOUD_UTILS  Path to RAMCloudUtils directory. Needed for finding "
  echo "                  ImageFileHashPartitioner."
  echo "  CL_DATASET_DIR  Where to store finished dataset in CloudLab storage."
  echo "                  Will automatically create a directory called "
  echo "                  tablets-N here."

  exit
fi

DATASET_DIR=$1
SERVER_LIST=$2
REMOTE_DIR=$3
GRAPH_NAME=$4
RAMCLOUD_UTILS=$5
CL_DATASET_DIR=$6

# Read in the server list as an array
while read -r hostname
do
  if [[ ! $hostname =~ ^#.* ]]
  then
    hosts+=($hostname)
  fi
done < ${SERVER_LIST}

NUM_SERVERS=${#hosts[@]}

N=$(ls ${DATASET_DIR}/social_network/ | grep comment_hasCreator_person | awk -F'_' 'BEGIN{max=0} {if (max < $4) max = $4} END{print $4 + 1}')

if (( NUM_SERVERS < N ))
then
  echo "ERROR: Need ${N} servers but only ${NUM_SERVER} in ${SERVER_LIST}."
  exit
fi

echo "Distributing files to servers' local disk..."
./distribute-partitioned-ldbc-snb-dataset.sh ${DATASET_DIR} ${N} ${SERVER_LIST} ${REMOTE_DIR}
echo 

echo "Converting dataset files to TorcDB images..."
./convert-ldbc-snb-dataset-to-torcdb-images.sh ${SERVER_LIST} ${REMOTE_DIR}/${DATASET_DIR} ${GRAPH_NAME}
echo 

echo "Dividing images into tablets..."
./partition-torcdb-images-into-ramcloud-tablets.sh ${RAMCLOUD_UTILS} ${SERVER_LIST} ${REMOTE_DIR}/${DATASET_DIR}/image_files ${N}
echo 

echo "Merging tablets together and compressing them..."
./shuffle-merge-and-compress-ramcloud-tablet-images.sh ${SERVER_LIST} ${REMOTE_DIR}/${DATASET_DIR}/image_files
echo

echo "Moving compressed tablets back to CloudLab dataset..."
mkdir -p ${CL_DATASET_DIR}/tablets-${N}
./copy-compressed-tablets-to-cloudlab-dataset.sh ${SERVER_LIST} ${REMOTE_DIR}/${DATASET_DIR}/image_files ${CL_DATASET_DIR}/tablets-${N}
echo

echo "Done!"
