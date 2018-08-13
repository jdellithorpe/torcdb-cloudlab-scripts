#!/bin/bash

if [[ $# != 3 ]]
then
  echo "Copy TorcDB image files to each of N servers' local disk."
  echo ""
  echo "Usage: distribute-torcdb-image-files.sh DATASET_DIR SERVER_LIST REMOTE_DIR"
  echo "  DATASET_DIR     Directory containing one folder per RAMCloud table "
  echo "                  with compressed tablet image files in each. Tablets "
  echo "                  are distributed to servers 1 tablet per server."
  echo "  SERVER_LIST     List of hostnames of the servers to copy the "
  echo "                  images to, one per line. If there are more than N "
  echo "                  servers, will use the first N."
  echo "  REMOTE_DIR      Local disk directory on remote host to copy files "
  echo "                  to."

  exit
fi

DATASET_DIR=$1
SERVER_LIST=$2
REMOTE_DIR=$3

CONCURRENT_TRANSFERS=3

# Read in the server list as an array
while read -r hostname
do
  if [[ ! $hostname =~ ^#.* ]]
  then
    hosts+=($hostname)
  fi
done < ${SERVER_LIST}

NUM_SERVERS=${#hosts[@]}

N=$(find ${DATASET_DIR} -name '*.gz' | sed 's/.*tablet\([0-9]*\)(.*/\1/' | awk 'BEGIN{max=0} {if (max < $1) max=$1} END{print max}')

if (( NUM_SERVERS < N ))
then
  echo "ERROR: Only $NUM_SERVERS servers in $SERVER_LIST, but need $N"
  exit
fi

pids=()
for (( i = 0; i < $N; i++ ))
do
  if (( ${#pids[@]} >= $CONCURRENT_TRANSFERS ))
  then
    wait ${pids[0]}
    newpids=()
    for (( j = 1; j < ${#pids[@]}; j++ ))
    do
      newpids+=("${pids[$j]}")
    done
    pids=("${newpids[@]}")
  fi

  echo "Copying files to ${hosts[$i]}... "
  file_listing=$(find ${DATASET_DIR} -name '*.gz' | grep "tablet$((i+1))(")
  file_array=()
  for file in $file_listing
  do 
    file_array+=($file)
  done
  ( tar -c "${file_array[@]}" 2>/dev/null | ssh ${hosts[$i]} "tar -xvf - -C ${REMOTE_DIR}" >/dev/null; echo "Files copied to ${hosts[$i]}!" ) &
  pids+=($!)
done

for pid in ${pids[@]}
do
  wait $pid
done

