#!/bin/bash

if [[ $# != 2 ]]
then
  echo "Execute COMMAND on servers in SERVER_LIST using pdsh."
  echo ""
  echo "Usage: pdsh.sh SERVER_LIST COMMAND"
  echo "  SERVER_LIST      List of hostnames listed one per line."
  echo "  COMMAND          Command to be executed on each of the hosts."

  exit
fi

SERVER_LIST=$1
COMMAND=$2

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

echo ${hosts[@]} | pdsh -R ssh -w - "${COMMAND}"
