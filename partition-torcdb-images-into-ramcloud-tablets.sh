#!/bin/bash

if [[ $# != 4 ]]
then
  echo "Take TorcDB image files distributed across a set of servers and "
  echo "partition each into set of N tablets."
  echo ""
  echo "Usage: partition-torcdb-images-into-ramcloud-tablets.sh SERVER_LIST REMOTE_DIR N"
  echo "  RAMCLOUD_UTILS   RAMCloudUtils directory."
  echo "  SERVER_LIST      List of hostnames of the servers that have "
  echo "                   torcdb image files, one per line."
  echo "  REMOTE_DIR       Location of the images files on the remote "
  echo "                   hosts. Expects directory of folders named after "
  echo "                   TorcDB tables, containing a set of image files that"
  echo "                   make up that table."
  echo "  N                Number of tablets to partition image files into."

  exit
fi

RAMCLOUD_UTILS=$1
SERVER_LIST=$2
REMOTE_DIR=$3
N=$4

# Read in the server list as an array
while read -r hostname
do
  if [[ ! $hostname =~ ^#.* ]]
  then
    hosts+=($hostname)
  fi
done < ${SERVER_LIST}

NUM_SERVERS=${#hosts[@]}

if [[ ! -f "${RAMCLOUD_UTILS}/ImageFileHashPartitioner" ]]
then
  cd ${RAMCLOUD_UTILS}
  make ImageFileHashPartitioner
  cd -
fi


echo ${hosts[@]} | pdsh -R ssh -w - "export LD_LIBRARY_PATH=/shome/jde/RAMCloud/obj.jni-updates; cd ${REMOTE_DIR}; for tableName in \$(ls); do echo \"Partitioning table \${tableName} on host \$(hostname --short)...\"; if [[ \${tableName} =~ vertexTable$ ]]; then tableId=1; elif [[ \${tableName} =~ edgeListTable$ ]]; then tableId=2; else echo \"Do not recognize table name \${tableName} and do not know which tableId to choose. Cowardly exiting!\"; exit; fi; for imageFile in \$(ls \${tableName}); do ${RAMCLOUD_UTILS}/ImageFileHashPartitioner --inputFile \${tableName}/\${imageFile} --tableId \${tableId} --serverSpan ${N} --outputDir \${tableName}; rm \${tableName}/\${imageFile}; done; done"
