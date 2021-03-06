#!/bin/bash

if [[ $# != 4 ]]
then
  echo "Take TorcDB image files distributed across a set of servers and "
  echo "upload them to a running RAMCloud instance in parallel. This script "
  echo "assumes that the server list contains exactly the servers that contain "
  echo "the image files." 
  echo ""
  echo "Usage: upload-distributed-torcdb-image-files.sh SERVER_LIST REMOTE_DIR RC_COORD_LOC RAMCLOUD_UTILS"
  echo "  SERVER_LIST      List of hostnames of the servers that have "
  echo "                   partitions of the image files, one per line."
  echo "  REMOTE_DIR       Location of the image partitions on the remote "
  echo "                   hosts. Expects folders per table with compressed "
  echo "                   image files."
  echo "  RC_COORD_LOC     RAMCloud coordinator locator."
  echo "  RAMCLOUD_UTILS   Path to RAMCloudUtils directory."

  exit
fi

SERVER_LIST=$1
REMOTE_DIR=$2
RC_COORD_LOC=$3
RAMCLOUD_UTILS=$4

# Uncomment tis line to upload datasets using DPDK. 
#RC_OPS="--dpdkPort 1"

# Read in the server list as an array
while read -r hostname
do
  if [[ ! $hostname =~ ^#.* ]]
  then
    hosts+=($hostname)
  fi
done < ${SERVER_LIST}

NUM_SERVERS=${#hosts[@]}

graphName=$(ssh ${hosts[0]} "cd ${REMOTE_DIR}; ls | grep vertexTable | sed -e 's/\(.*\)_vertexTable/\1/'")

if [[ ! -f "${RAMCLOUD_UTILS}/TableCreator" ]]
then
  cd ${RAMCLOUD_UTILS}
  make TableCreator
  cd -
fi

${RAMCLOUD_UTILS}/TableCreator -C ${RC_COORD_LOC} --tableNames ${graphName}_vertexTable,${graphName}_edgeListTable --serverSpan ${NUM_SERVERS}

if [[ ! -f "${RAMCLOUD_UTILS}/SnapshotLoader" ]]
then
  cd ${RAMCLOUD_UTILS}
  make SnapshotLoader
  cd -
fi

echo ${hosts[@]} | pdsh -R ssh -w - "export LD_LIBRARY_PATH=/shome/jde/RAMCloud/obj.torcdb-experiments; cd ${REMOTE_DIR}; for tableName in \$(ls); do for imageFile in \$(ls \${tableName}); do gunzip -c \${tableName}/\${imageFile} | ${RAMCLOUD_UTILS}/SnapshotLoader -C ${RC_COORD_LOC} --tableName \${tableName} --serverSpan ${NUM_SERVERS} ${RC_OPTS}; done; done"
