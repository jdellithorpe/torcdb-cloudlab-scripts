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
  done <<< "$(head -n $[count+1] /scratch/jdellit/datasets/ldbc-snb/${dataset}/substitution_parameters/interactive_${number}_param.txt | tail -n $count)"
#  done <<< "$(head -n $[count+1] /datasets/ldbc-snb/${dataset}/substitution_parameters/interactive_${number}_param.txt | tail -n $count)"
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
#execQuery "7" "10" "0" "${dataset}" "1"
#execQuery "8" "10" "0" "${dataset}" "1"
#execQuery "4" "10" "0" "${dataset}" "1"
#execQuery "11" "10" "0" "${dataset}" "1"
#execQuery "1" "10" "0" "${dataset}" "1"
#execQuery "2" "10" "0" "${dataset}" "1"
#execQuery "12" "10" "0" "${dataset}" "1"
#execQuery "10" "10" "0" "${dataset}" "1"
#execQuery "13" "10" "0" "${dataset}" "1"
#execQuery "14" "10" "0" "${dataset}" "1"
#execQuery "6" "10" "0" "${dataset}" "1"
#execQuery "5" "10" "0" "${dataset}" "1"
#execQuery "9" "10" "0" "${dataset}" "1"
#execQuery "3" "10" "0" "${dataset}" "1"

# Real Set
# Estimated time: less than one minute
#execQuery "7" "4486" "10" "${dataset}" "0" # Mean: 256 us // 4486x1
## Estimated time: less than one minute
#execQuery "8" "4486" "10" "${dataset}" "0" # Mean: 355 us // 4486x1
## Estimated time: 21 minutes
#execQuery "4" "4486" "10" "${dataset}" "0" # Mean: 29 ms // 4486x1
## Estimated time: 21 minutes
#execQuery "11" "4486" "10" "${dataset}" "0" # Mean: 28 ms // 4486x1
## Estimated time: 86 minutes
#execQuery "2" "4486" "10" "${dataset}" "0" # Mean: 116 ms // 4486x1
## Each of these below is calibrated to take ~2 hours for a total of 18 hours.
#execQuery "12" "4486" "10" "${dataset}" "0" # Mean: 146 ms // 4486x1
#execQuery "1" "4486" "8" "${dataset}" "0" # Mean: 197 ms // 4486x1
#execQuery "10" "4486" "5" "${dataset}" "0" # Mean: 292 ms // 4486x1
#execQuery "6" "1750" "1" "${dataset}" "0" # Mean: 4.1 s // 100x1
#execQuery "13" "750" "1" "${dataset}" "0" # Mean: 9.5 s // 4486x1
#execQuery "14" "700" "1" "${dataset}" "0" # Mean: 10.4 s // 621x1
#execQuery "9" "250" "1" "${dataset}" "0" # Mean: 27.9 s // 10x1
#execQuery "5" "250" "1" "${dataset}" "0" # Mean: 29.1 s // 20x1
#execQuery "3" "175" "1" "${dataset}" "0" # Mean: 41.3 s // 10x1

# Real set in reverse
# Each of these below is calibrated to take ~2 hours for a total of 18 hours.
#execQuery "3" "175" "1" "${dataset}" "0" # Mean: 36.6 s // 175x1
#execQuery "5" "250" "1" "${dataset}" "0" # Mean: 29.7 s // 250x1
#execQuery "9" "250" "1" "${dataset}" "0" # Mean: 26.0 s // 250x1
#execQuery "14" "700" "1" "${dataset}" "0" # Mean: 10.3 s // 700x1
#execQuery "13" "750" "1" "${dataset}" "0" # Mean: 9.5 s // 4486x1
#execQuery "6" "1750" "1" "${dataset}" "0" # Mean: 3.9 s // 1750x1
#execQuery "10" "4486" "5" "${dataset}" "0" # Mean: 289 ms // 4486x5
#execQuery "1" "4486" "8" "${dataset}" "0" # Mean: 195 ms // 4486x8
#execQuery "12" "4486" "10" "${dataset}" "0" # Mean: 141 ms // 4486x10
## Estimated time: 86 minutes
#execQuery "2" "4486" "10" "${dataset}" "0" # Mean: 115 ms // 4486x10
## Estimated time: 21 minutes
#execQuery "11" "4486" "10" "${dataset}" "0" # Mean: 28 ms // 4486x10
## Estimated time: 21 minutes
#execQuery "4" "4486" "10" "${dataset}" "0" # Mean: 28 ms // 4486x10
## Estimated time: less than one minute
#execQuery "8" "4486" "10" "${dataset}" "0" # Mean: 249 us // 4486x10
## Estimated time: less than one minute
#execQuery "7" "4486" "10" "${dataset}" "0" # Mean: 194 us // 4486x10

#Neo4j 
# Estimated time: less than one minute
execQuery "8" "4486" "10" "${dataset}" "0" # Mean: 384 us // 4486x10
# Estimated time: less than one minute
execQuery "7" "4486" "10" "${dataset}" "0" # Mean: 598 us // 4486x10
# Estimated time: less than one minute
execQuery "13" "4486" "10" "${dataset}" "0" # Mean: 7.7 ms // 4486x1
# Estimated time: 9 minutes
execQuery "11" "4486" "10" "${dataset}" "0" # Mean: 119 ms // 4486x1
# Each of these below is calibrated to take ~2 hours for a total of 20 hours.
execQuery "2" "4486" "6" "${dataset}" "0" # Mean: 241 ms // 4486x1
execQuery "12" "4486" "4" "${dataset}" "0" # Mean: 364 ms // 4486x1
execQuery "10" "1900" "1" "${dataset}" "0" # Mean: 3.8 s // 10x1
execQuery "1" "1700" "1" "${dataset}" "0" # Mean: 4.2 s // 10x1
execQuery "5" "120" "1" "${dataset}" "0" # Mean: 61.4 s // 10x1
execQuery "9" "120" "1" "${dataset}" "0" # Mean: 1.9 m // 10x1
execQuery "3" "120" "1" "${dataset}" "0" # Mean: 4 m // 8x1
execQuery "4" "120" "1" "${dataset}" "0" # Mean: 8.2 m // 64x1
execQuery "14" "120" "1" "${dataset}" "0" # Mean: 43 m // 67x1
execQuery "6" "120" "1" "${dataset}" "0" # Mean: MAXED OUT // 10x1
