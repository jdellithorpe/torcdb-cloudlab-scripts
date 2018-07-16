#!/bin/bash

echo "Checking for slow machines... "

NUM_RCNODES=`cat /local/parameters.cfg | grep "NUM_RCNODES" | awk '{print $2}'`

for i in $(seq 1 $NUM_RCNODES)
do
  host=$(printf "rc%02d-ctrl" $i)
  if [ -z "$rcList" ]
  then
    rcList="$host"
  else
    rcList="$rcList","$host"
  fi
done

OUTPUT=`pdsh -R ssh -w ${rcList} 'perf bench sched all | grep "Total time" | head -n 1' | awk '{if ($4 > 0.2) {print $1" Seems slow: "$4" > 0.2"}}'`

if [ -z "$OUTPUT" ]
then
  echo "Passed!"
  echo
else
  echo "Failed! (See below)"
  echo "$OUTPUT"
  echo
fi

echo "Checking that DPDK has been installed... "

OUTPUT=`pdsh -R ssh -w ${rcList} 'cat /MLNX_OFED_LINUX-3.4-1.0.0.0-ubuntu16.04-x86_64/install.log | grep --count "Installation passed successfully"' 2>1 | awk '{if (!$2) {print "MLNX driver not installed successfully"}}'`

if [ -z "$OUTPUT" ]
then
  echo "Passed!"
  echo
else
  echo "Failed! (See below)"
  echo "$OUTPUT"
  echo
fi
