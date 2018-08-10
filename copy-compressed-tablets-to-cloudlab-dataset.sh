#!/bin/bash

if [[ $# != 3 ]]
then
  echo "Copy the compressed tablet image files, as produced by "
  echo "shuffle-merge-and-compress-ramcloud-tablet-images.sh to a CloudLab "
  echo "dataset for long term storage. Copying is staggered so as not to "
  echo "overwhelm RCNFS or the CloudLab storage backend."
  echo ""
  echo "Usage: copy-compressed-tablets-to-cloudlab-dataset.sh SERVER_LIST "
  echo "  SERVER_LIST      List of hostnames of the servers that have "
  echo "                   torcdb tablet image files, one per line."
  echo "  REMOTE_DIR       Location of the images files on the remote "
  echo "                   hosts. Expects directory of folders named after "
  echo "                   TorcDB tables, containing a set of tablet image "
  echo "                   files that make up that table."
  echo " CL_DATASET_DIR    CloudLab dataset directory where compressed tablet "
  echo "                   image files should be stored. These files will be "
  echo "                   transferred by way of rcnfs."

  exit
fi

SERVER_LIST=$1
REMOTE_DIR=$2
CL_DATASET_DIR=$3

# Read in the server list as an array
while read -r hostname
do
  if [[ ! $hostname =~ ^#.* ]]
  then
    hosts+=($hostname)
  fi
done < ${SERVER_LIST}

NUM_SERVERS=${#hosts[@]}

echo ${hosts[@]} | pdsh -R ssh -f 4 -w - "cd ${REMOTE_DIR}; file_listing=\$(find . -name '*.gz'); file_array=(); for file in \${file_listing}; do file_array+=(\${file}); done; tar -c \"\${file_array[@]}\" 2>/dev/null | ssh rcnfs \"tar -xvf - -C ${CL_DATASET_DIR}\" > /dev/null;"
