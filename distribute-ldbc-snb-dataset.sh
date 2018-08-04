#!/bin/bash
#
# Usage: Divide up LDBC SNB dataset files N ways and copy partitions to each of 
#         N servers' local disk.
# 
# distribute-ldbc-snb-dataset.sh DATASET_DIR SERVER_LIST REMOTE_DIR
#     DATASET_DIR     LDBC SNB dataset directory containing social_network/ and 
#                     social_network_supplementary_files/ directories.
#     SERVER_LIST     List of hostnames of the servers to copy the dataset to,
#                     one per line
#     REMOTE_DIR      Local disk directory on remote host to copy files to. Will
#                     create directories social_network/ and
#                     social_network_supplementary_files/ in this directory

if [[ $# != 3 ]]
then
  echo "Divide up LDBC SNB dataset files N ways and copy partitions to each of "
  echo "N servers' local disk."
  echo ""
  echo "Usage: distribute-ldbc-snb-dataset.sh DATASET_DIR SERVER_LIST REMOTE_DIR"
  echo "  DATASET_DIR     LDBC SNB dataset directory containing "
  echo "                  social_network/ and "
  echo "                  social_network_supplementary_files/ directories."
  echo "  SERVER_LIST     List of hostnames of the servers to copy the "
  echo "                  dataset to, one per line."
  echo "  REMOTE_DIR      Local disk directory on remote host to copy files "
  echo "                  to.  Will create directories social_network/ and "
  echo "                  social_network_supplementary_files/ in this "
  echo "                  directory."

  exit
fi

DATASET_DIR=$1
SERVER_LIST=$2
REMOTE_DIR=$3

# Read in the server list as an array
while read -r hostname
do
  if [[ ! $hostname =~ ^#.* ]]
  then
    hosts=("${hosts[@]}" "$hostname")
  fi
done < ${SERVER_LIST}

NUM_SERVERS=${#hosts[@]}

file_listing=$(for file in $(find ${DATASET_DIR}/social_network ${DATASET_DIR}/social_network_supplementary_files -name '*.csv' | grep -v 'social_network/person_[0-9]*_[0-9]*.csv' | grep -v 'social_network/person_\(email\|speaks\|knows\).*.csv'); do du $file; done | sort -rn | awk '{print $2}')
size_listing=$(for file in $(find ${DATASET_DIR}/social_network ${DATASET_DIR}/social_network_supplementary_files -name '*.csv' | grep -v 'social_network/person_[0-9]*_[0-9]*.csv' | grep -v 'social_network/person_\(email\|speaks\|knows\).*.csv'); do du $file; done | sort -rn | awk '{print $1}')

file_array=()
for file in $file_listing
do 
  file_array+=($file)
done

size_array=()
size_total=0
for size in $size_listing
do 
  size_array+=($size)
  (( size_total += $size ))
done

(( file_partition_target_size = ${size_total}/${NUM_SERVERS} ))

echo "Using servers: ${hosts[@]}"
echo "Total servers: ${NUM_SERVERS}"
echo "Total file size: ${size_total} (target ${file_partition_target_size} per server)"

for (( i = 0; i < ${#hosts[@]}; i++ ))
do
  if (( i == ${#hosts[@]} - 1 ))
  then
    # If this is the last host, give them the remaining files.
    size_sum=0
    for (( j = 0; j < ${#file_array[@]}; j++ ))
    do
      (( size_sum += ${size_array[$j]} ))
    done

    echo "Copying "${size_sum}" bytes in "${#file_array[@]}" files to "${hosts[$i]}
    tar -c "${file_array[@]}" 2>/dev/null | ssh ${hosts[$i]} "tar -xvf - -C ${REMOTE_DIR}" >/dev/null
  else
    # Find subset of files that add up to our target size
    remaining_file_array=()
    remaining_size_array=()
    selected_file_array=()
    size_sum=0
    for (( j = 0; j < ${#file_array[@]}; j++ ))
    do
      if (( ${size_sum} + ${size_array[$j]} <= ${file_partition_target_size} ))
      then
        (( size_sum += ${size_array[$j]} ))
        selected_file_array+=(${file_array[$j]})
      else
        remaining_file_array+=(${file_array[$j]})
        remaining_size_array+=(${size_array[$j]})
      fi
    done
 
    echo "Copying "${size_sum}" bytes in "${#selected_file_array[@]}" files to "${hosts[$i]}
    tar -c "${selected_file_array[@]}" 2>/dev/null | ssh ${hosts[$i]} "tar -xvf - -C ${REMOTE_DIR}" >/dev/null

    file_array=("${remaining_file_array[@]}")
    size_array=("${remaining_size_array[@]}")
  fi
done
