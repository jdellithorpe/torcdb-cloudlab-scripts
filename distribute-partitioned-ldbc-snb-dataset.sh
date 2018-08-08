#!/bin/bash

if [[ $# != 4 ]]
then
  echo "Copy partitions to each of N servers' local disk."
  echo ""
  echo "Usage: distribute-partitioned-ldbc-snb-dataset.sh DATASET_DIR N SERVER_LIST REMOTE_DIR"
  echo "  DATASET_DIR     LDBC SNB dataset directory containing "
  echo "                  social_network/ and "
  echo "                  social_network_supplementary_files/ directories "
  echo "                  divided into N partitions."
  echo "  N               Number of partitions dataset is divided into."
  echo "  SERVER_LIST     List of hostnames of the servers to copy the "
  echo "                  dataset to, one per line. If there are more than N "
  echo "                  servers, will use the first N."
  echo "  REMOTE_DIR      Local disk directory on remote host to copy files "
  echo "                  to.  Will create directories social_network/ and "
  echo "                  social_network_supplementary_files/ in this "
  echo "                  directory."

  exit
fi

DATASET_DIR=$1
N=$2
SERVER_LIST=$3
REMOTE_DIR=$4

# Read in the server list as an array
while read -r hostname
do
  if [[ ! $hostname =~ ^#.* ]]
  then
    hosts+=($hostname)
  fi
done < ${SERVER_LIST}

NUM_SERVERS=${#hosts[@]}

if (( NUM_SERVERS < N ))
then
  echo "Only $NUM_SERVERS servers in $SERVER_LIST, but need $N"
  exit
fi

for (( i = 0; i < $N; i++ ))
do
  echo -n "Copying files to ${hosts[$i]}... "
  file_listing=$(find ${DATASET_DIR}/social_network ${DATASET_DIR}/social_network_supplementary_files -name '*.csv' | grep -v 'social_network/person_[0-9]*_[0-9]*.csv' | grep -v 'social_network/person_\(email\|speaks\|knows\).*.csv' | grep "${i}_0.csv")
  file_array=()
  for file in $file_listing
  do 
    file_array+=($file)
  done
  tar -c "${file_array[@]}" 2>/dev/null | ssh ${hosts[$i]} "tar -xvf - -C ${REMOTE_DIR}" >/dev/null
  echo "Done!"
done
