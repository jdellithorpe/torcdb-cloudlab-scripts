#!/bin/bash

declare -a query_argfmts
query_argfmts[1]="\${args[0]} \${args[1]} 20"
query_argfmts[2]="\${args[0]} \${args[1]} 20"
query_argfmts[3]="\${args[0]} \${args[3]} \${args[4]} \${args[1]} \${args[2]} 20"
query_argfmts[4]="\${args[0]} \${args[1]} \${args[2]} 10"
query_argfmts[5]="\${args[0]} \${args[1]} 20"
query_argfmts[6]="\${args[0]} \${args[1]} 10"
query_argfmts[7]="\${args[0]} 20"
query_argfmts[8]="\${args[0]} 20"
query_argfmts[9]="\${args[0]} \${args[1]} 20"
query_argfmts[10]="\${args[0]} \${args[1]} 10"
query_argfmts[11]="\${args[0]} \${args[1]} \${args[2]} 10"
query_argfmts[12]="\${args[0]} \${args[1]} 20"
query_argfmts[13]="\${args[0]} \${args[1]}"
query_argfmts[14]="\${args[0]} \${args[1]}"

execQuery() {
  number=$1
  count=$2
  repeat=$3
  dataset=$4
  while IFS='|' read -ra args
  do 
    eval "echo \"cmd=[query${number} ${query_argfmts[number]} --repeat ${repeat}]\""
    eval "./bin/QueryTester.sh query${number} ${query_argfmts[number]} --repeat ${repeat}" 2>/dev/null | grep "^LdbcQuery[0-9]\+Result{.*}"
  done <<< "$(head -n $[count+1] /datasets/ldbc-snb/${dataset}/substitution_parameters/interactive_${number}_param.txt | tail -n $count)"
}

# Number of unique queries to execute from dataset.
query_count=10
# The dataset from which to draw query parameters.
dataset="ldbc_snb_sf0001"

for ((i = 1; i <= 14; i++))
do
  echo "Collecting ${query_count} query results for query${i}..." 
  execQuery ${i} ${query_count} 1 ${dataset} > query${i}_${dataset}_results.txt
done
