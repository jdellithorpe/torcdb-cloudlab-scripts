#!/bin/bash

declare -a query_argfmts
query_argfmts[1]="\${args[0]} \\\"\${args[1]}\\\" 20"
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
  warmup_count=$5
  param_set_nr=0
  while IFS='|' read -ra args
  do 
    if (( param_set_nr < warmup_count ))
    then
      eval "echo \"query${number} ${query_argfmts[number]} --warmUp 60 --repeat ${repeat} --timeUnits=MICROSECONDS\""
    else
      eval "echo \"query${number} ${query_argfmts[number]} --repeat ${repeat} --timeUnits=MICROSECONDS\""
    fi

    (( param_set_nr++ ))
#  done <<< "$(head -n $[count+1] /scratch/jdellit/datasets/ldbc-snb/${dataset}/substitution_parameters/interactive_${number}_param.txt | tail -n $count)"
  done <<< "$(head -n $[count+1] /datasets/ldbc-snb/${dataset}/substitution_parameters/interactive_${number}_param.txt | tail -n $count)"
}

# Number of unique queries to execute from dataset.
#query_count=10
# Number of times to repeat each query.
#query_repeat_count=1000
# The dataset from which to draw query parameters.
dataset="ldbc_snb_sf0100"

#for ((i = 2; i <= 2; i++))
#do
#  execQuery "${i}" "${query_count}" "${query_repeat_count}" "${dataset}"
#done

# To print out the first of each query substitution parameters
#execQuery "1" "1" "1" "${dataset}"
#execQuery "2" "1" "1" "${dataset}"
#execQuery "3" "1" "1" "${dataset}"
#execQuery "4" "1" "1" "${dataset}"
#execQuery "5" "1" "1" "${dataset}"
#execQuery "6" "1" "1" "${dataset}"
#execQuery "7" "1" "1" "${dataset}"
#execQuery "8" "1" "1" "${dataset}"
#execQuery "9" "1" "1" "${dataset}"
#execQuery "10" "1" "1" "${dataset}"
#execQuery "11" "1" "1" "${dataset}"
#execQuery "12" "1" "1" "${dataset}"
#execQuery "13" "1" "1" "${dataset}"
#execQuery "14" "1" "1" "${dataset}"


# For TorcDB
#execQuery "7" "${query_count}" "100" "${dataset}"
#execQuery "8" "${query_count}" "100" "${dataset}"
#execQuery "4" "${query_count}" "100" "${dataset}"
#execQuery "11" "${query_count}" "100" "${dataset}"
#execQuery "1" "${query_count}" "100" "${dataset}"
#execQuery "2" "${query_count}" "100" "${dataset}"
#execQuery "12" "${query_count}" "100" "${dataset}"
#execQuery "10" "${query_count}" "100" "${dataset}"
#execQuery "13" "${query_count}" "25" "${dataset}"
#execQuery "14" "${query_count}" "25" "${dataset}"
#execQuery "6" "${query_count}" "10" "${dataset}"
#execQuery "5" "${query_count}" "5" "${dataset}"
#execQuery "9" "${query_count}" "5" "${dataset}"
#execQuery "3" "${query_count}" "5" "${dataset}"

# TorcDB2
# WarmUp
execQuery "7" "1" "0" "${dataset}" "1"
execQuery "8" "1" "0" "${dataset}" "1"
execQuery "4" "1" "0" "${dataset}" "1"
execQuery "11" "1" "0" "${dataset}" "1"
execQuery "1" "1" "0" "${dataset}" "1"
execQuery "2" "1" "0" "${dataset}" "1"
execQuery "12" "1" "0" "${dataset}" "1"
execQuery "10" "1" "0" "${dataset}" "1"
execQuery "13" "1" "0" "${dataset}" "1"
execQuery "14" "1" "0" "${dataset}" "1"
execQuery "6" "1" "0" "${dataset}" "1"
execQuery "5" "1" "0" "${dataset}" "1"
execQuery "9" "1" "0" "${dataset}" "1"
execQuery "3" "1" "0" "${dataset}" "1"

# Real Set
execQuery "7" "4486" "1" "${dataset}" "0"
execQuery "8" "4486" "1" "${dataset}" "0"
execQuery "4" "4486" "1" "${dataset}" "0"
execQuery "11" "4486" "1" "${dataset}" "0"
execQuery "1" "4486" "1" "${dataset}" "0"
execQuery "2" "4486" "1" "${dataset}" "0"
execQuery "12" "4486" "1" "${dataset}" "0"
execQuery "10" "4486" "1" "${dataset}" "0"
execQuery "13" "4486" "1" "${dataset}" "0"
execQuery "14" "360" "1" "${dataset}" "0"
execQuery "6" "100" "1" "${dataset}" "0"
execQuery "5" "20" "1" "${dataset}" "0"
execQuery "9" "10" "1" "${dataset}" "0"
execQuery "3" "10" "1" "${dataset}" "0"

#Neo4j 
#execQuery "7" "4486" "1" "${dataset}"
#execQuery "8" "4486" "1" "${dataset}"
#execQuery "13" "4486" "1" "${dataset}"
#execQuery "2" "4486" "1" "${dataset}"
#execQuery "11" "4486" "1" "${dataset}"
#execQuery "12" "4486" "1" "${dataset}"
#execQuery "14" "4486" "1" "${dataset}"
#execQuery "10" "200" "1" "${dataset}"
#execQuery "1" "200" "1" "${dataset}"
#execQuery "5" "200" "1" "${dataset}"
#execQuery "9" "100" "1" "${dataset}"
#execQuery "3" "100" "1" "${dataset}"
#execQuery "6" "100" "1" "${dataset}"
#execQuery "4" "100" "1" "${dataset}"
