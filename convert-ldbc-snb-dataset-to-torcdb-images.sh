#!/bin/bash

if [[ $# != 2 ]]
then
  echo "Take LDBC SNB dataset files distributed across a set of servers and "
  echo "convert them to TorcDB RAMCloud image files in parallel."
  echo ""
  echo "Usage: convert-ldbc-snb-dataset-to-torcdb-images.sh SERVER_LIST REMOTE_DIR"
  echo "  SERVER_LIST      List of hostnames of the servers that have "
  echo "                   partitions of the dataset, one per line."
  echo "  REMOTE_DIR       Location of the dataset partitions on the remote "
  echo "                   hosts. Expects social_network/ and "
  echo "                   social_network_supplementary_files/ in this "
  echo "                   directory."

  exit
fi

SERVER_LIST=$1
REMOTE_DIR=$2

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Read in the server list as an array
while read -r hostname
do
  if [[ ! $hostname =~ ^#.* ]]
  then
    hosts+=($hostname)
  fi
done < ${SERVER_LIST}

NUM_SERVERS=${#hosts[@]}

# Prep maven exec plugin
mvn exec:java -Dexec.mainClass="net.ellitron.ldbcsnbimpls .interactive.torc.util.ImageMaker" -Dexec.args="" > /dev/null 2>&1

echo ${hosts[@]} | pdsh -R ssh -w - "cd ${SCRIPTPATH}; mvn exec:java -Dexec.mainClass=\"net.ellitron.ldbcsnbimpls.interactive.torc.util.ImageMaker\" -Dexec.args=\"--mode all --outputDir ${REMOTE_DIR} --noLabelList --graphName graph --numThreads 4 --reportInt 2 --reportFmt LFDT ${REMOTE_DIR}/social_network ${REMOTE_DIR}/social_network_supplementary_files\""
