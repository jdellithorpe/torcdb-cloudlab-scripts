#!/bin/bash

if [[ $# != 2 ]]
then
  echo "Clear the remote directory on each of the servers in in the server list"
  echo ""
  echo "Usage: clear-remote-dir.sh REMOTE_DIR SERVER_LIST"
  echo "  REMOTE_DIR      Local disk directory on remote hosts to delete files "
  echo "                  from."
  echo "  SERVER_LIST     List of hostnames of the servers to clear the "
  echo "                  file from, one per line."

  exit
fi

REMOTE_DIR=$1
SERVER_LIST=$2

# Read in the server list as a comma seperated list for use with pdsh.
while read -r hostname
do
  if [[ ! $hostname =~ ^#.* ]]
  then
    if [ -z "$rcList" ]
    then
      rcList="$hostname"
    else
      rcList="$rcList","$hostname"
    fi
  fi
done < ${SERVER_LIST}

pdsh -R ssh -w ${rcList} "rm -rf ${REMOTE_DIR}/*"
