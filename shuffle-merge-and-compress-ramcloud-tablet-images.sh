#!/bin/bash

if [[ $# != 2 ]]
then
  echo "Take RAMCloud tablet files created from hash partitioned TorcDB images "
  echo "spread across a set of servers and consolidate the tablet images so "
  echo "that each server has a complete set of tablet images. Tablets are "
  echo "moved to servers in the order they appear in the server list (e.g. "
  echo "tablet 1 goes to the first server in the server list). Tablet files are"
  echo "merged at the end so that the final result is each server has a single"
  echo "consolidated tablet image file."
  echo "" 
  echo "Usage: shuffle-and-merge-ramcloud-tablet-images.sh SERVER_LIST REMOTE_DIR N"
  echo "  SERVER_LIST      List of hostnames of the servers that have "
  echo "                   torcdb tablet image files, one per line."
  echo "  REMOTE_DIR       Location of the images files on the remote "
  echo "                   hosts. Expects directory of folders named after "
  echo "                   TorcDB tables, containing a set of tablet image "
  echo "                   files that make up that table."

  exit
fi

SERVER_LIST=$1
REMOTE_DIR=$2

# Read in the server list as an array
while read -r hostname
do
  if [[ ! $hostname =~ ^#.* ]]
  then
    hosts+=($hostname)
  fi
done < ${SERVER_LIST}

NUM_SERVERS=${#hosts[@]}

# Prepend hostname to files on each host so that shuffling does not clobber
# itself.
echo ${hosts[@]} | pdsh -R ssh -w - "for file in \$(find ${REMOTE_DIR} -name '*.img'); do mv \${file} \$(dirname \${file})/\$(hostname --short).\$(basename \${file}); done"

# Do the shuffling.
echo ${hosts[@]} | pdsh -R ssh -w - "hosts=(${hosts[@]}); for (( tabletNum = 1; ; tabletNum++ )); do if [[ \${hosts[\${tabletNum} - 1]} == \$(hostname --short) ]]; then continue; fi; tablet_listing=\$(find ${REMOTE_DIR} -name \"*tablet\${tabletNum}*.img\"); if [[ -z \"\${tablet_listing}\" ]]; then exit; fi; file_array=(); for file in \${tablet_listing}; do file_array+=(\${file}); done; echo \"Sending tablet \${tabletNum} to \${hosts[\${tabletNum} - 1]}...\"; tar -c \"\${file_array[@]}\" 2>/dev/null | ssh \${hosts[\${tabletNum} - 1]} \"tar -xvf - -C /\" > /dev/null; rm \"\${file_array[@]}\"; done" 

# Merge tablet image files
echo ${hosts[@]} | pdsh -R ssh -w - "cd ${REMOTE_DIR}; for tableName in \$(ls); do echo \"Merging \${tableName} tablets...\"; for imageFile in \$(ls \${tableName}); do cat \${tableName}/\${imageFile} >> \${tableName}/\${imageFile#*.*.}; rm \${tableName}/\${imageFile}; done; done"

# Merge tablet image files
echo ${hosts[@]} | pdsh -R ssh -w - "cd ${REMOTE_DIR}; for tableName in \$(ls); do for imageFile in \$(ls \${tableName}); do echo \"Compressing \${tableName}/\${imageFile}...\"; gzip \${tableName}/\${imageFile}; done; done"
