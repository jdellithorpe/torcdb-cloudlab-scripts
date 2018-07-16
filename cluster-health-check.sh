#!/bin/bash

NUM_RCNODES=`cat /local/parameters.cfg | grep "NUM_RCNODES" | awk '{print $2}'`

hostArray=()
for i in $(seq 1 $NUM_RCNODES)
do
  host=$(printf "rc%02d" $i)
  if [ -z "$hostList" ]
  then
    hostList="$host"
  else
    hostList="$hostList","$host"
  fi
done

pdsh -R ssh -w ${hostList} 'perf bench sched all | grep "Total time" | head -n 1' | awk '{if ($4 > 0.14) {slowness=1; print $1" Seems slow: "$4" > 0.14"}} END {if (slowness) {print "Slow servers detected..."} else {print "All servers seem healthy!"}}'
