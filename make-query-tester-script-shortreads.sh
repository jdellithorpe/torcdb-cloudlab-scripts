#!/bin/bash

declare -a query_argfmts
query_argfmts[1]="\${args[0]}"      # personId
query_argfmts[2]="\${args[0]} 10"   # personId limit
query_argfmts[3]="\${args[0]}"      # personId
query_argfmts[4]="\${args[0]}"      # commentId
query_argfmts[5]="\${args[0]}"      # commentId
query_argfmts[6]="\${args[0]}"      # commentId
query_argfmts[7]="\${args[0]}"      # commentId
query_argfmts[8]="\${args[0]}"      # postId
query_argfmts[9]="\${args[0]}"      # postId
query_argfmts[10]="\${args[0]}"     # postId
query_argfmts[11]="\${args[0]}"     # postId

execQuery() {
  number=$1
  count=$2
  repeat=$3
  dataset=$4
  warmup_count=$5
  param_set_nr=0
  if (( number < 4  ))
  then
#    file="/scratch/jdellit/datasets/ldbc-snb/${dataset}/id_lists/personIDs.csv"
    file="/datasets/ldbc-snb/${dataset}/id_lists/personIDs_shuffled_top10000.csv"
  elif (( number < 8 ))
  then
#    file="/scratch/jdellit/datasets/ldbc-snb/${dataset}/id_lists/commentIDs.csv"
    file="/datasets/ldbc-snb/${dataset}/id_lists/commentIDs_shuffled_top10000.csv"
  else
#    file="/scratch/jdellit/datasets/ldbc-snb/${dataset}/id_lists/postIDs.csv"
    file="/datasets/ldbc-snb/${dataset}/id_lists/postIDs_shuffled_top10000.csv"
  fi

  if (( number > 7 ))
  then
    (( number = number - 4 ))
  fi

  while IFS='|' read -ra args
  do 
    if (( param_set_nr < warmup_count ))
    then
      eval "echo \"shortquery${number} ${query_argfmts[number]} --warmUp 60 --repeat ${repeat} --timeUnits=MICROSECONDS\""
    else
      eval "echo \"shortquery${number} ${query_argfmts[number]} --repeat ${repeat} --timeUnits=MICROSECONDS\""
    fi

    (( param_set_nr++ ))
  done <<< "$(head -n $count ${file})"
}

# For validation results collection
#dataset="ldbc_snb_sf0001"
#execQuery "1"  "10000" "1" "${dataset}"
#execQuery "2"  "10000" "1" "${dataset}"
#execQuery "3"  "10000" "1" "${dataset}"
#execQuery "4"  "10000" "1" "${dataset}"
#execQuery "5"  "10000" "1" "${dataset}"
#execQuery "6"  "10000" "1" "${dataset}"
#execQuery "7"  "10000" "1" "${dataset}"
#execQuery "8"  "10000" "1" "${dataset}"
#execQuery "9"  "10000" "1" "${dataset}"
#execQuery "10" "10000" "1" "${dataset}"
#execQuery "11" "10000" "1" "${dataset}"

# For performance results collection
#dataset="ldbc_snb_sf0001"
#execQuery "1"  "10000" "10" "${dataset}"
#execQuery "2"  "10000" "10" "${dataset}"
#execQuery "3"  "10000" "10" "${dataset}"
#execQuery "4"  "10000" "10" "${dataset}"
#execQuery "5"  "10000" "10" "${dataset}"
#execQuery "6"  "10000" "10" "${dataset}"
#execQuery "7"  "10000" "10" "${dataset}"
#execQuery "8"  "10000" "10" "${dataset}"
#execQuery "9"  "10000" "10" "${dataset}"
#execQuery "10" "10000" "10" "${dataset}"
#execQuery "11" "10000" "10" "${dataset}"

# For performance exploration
#dataset="ldbc_snb_sf0001"
#execQuery "1"  "10000" "10" "${dataset}" # TorcDB2 Exec Time: 3.5 m, TorcDB2 Mean Time: 463 us
#execQuery "2"  "10000" "10" "${dataset}" # TorcDB2 Exec Time: 30 m, TorcDB2 Mean Time: 14.8 ms
#execQuery "3"  "10000" "10" "${dataset}" # TorcDB2 Exec Time: 5.5 m, TorcDB2 Mean Time: 1.5 ms
#execQuery "4"  "10000" "10" "${dataset}" # TorcDB2 Exec Time: 3.3 m, TorcDB2 Mean Time: 242 us
#execQuery "5"  "10000" "10" "${dataset}" # TorcDB2 Exec Time: 3.5 m, TorcDB2 Mean Time: 444 us
#execQuery "6"  "10000" "10" "${dataset}" # TorcDB2 Exec Time: 4.75 m, TorcDB2 Mean Time: 1.3 ms
#execQuery "7"  "10000" "10" "${dataset}" # TorcDB2 Exec Time: 4.13 m, TorcDB2 Mean Time: 873 us
#execQuery "8"  "10000" "10" "${dataset}" # TorcDB2 Exec Time: ~3.4 m, TorcDB2 Mean Time: 249 us
#execQuery "9"  "10000" "10" "${dataset}" # TorcDB2 Exec Time: ~3.5 m, TorcDB2 Mean Time: 434 us
#execQuery "10" "10000" "10" "${dataset}" # TorcDB2 Exec Time: ~4.0 m, TorcDB2 Mean Time: 1.1 ms
#execQuery "11" "10000" "10" "${dataset}" # TorcDB2 Exec Time: ~4.0 m, TorcDB2 Mean Time: 832 us

# For performance results collection
dataset="ldbc_snb_sf0100"
#execQuery "1"  "10000" "10" "${dataset}"
#execQuery "2"  "10000" "10" "${dataset}"
#execQuery "3"  "10000" "10" "${dataset}"
#execQuery "4"  "10000" "10" "${dataset}"
#execQuery "5"  "10000" "10" "${dataset}"
#execQuery "6"  "10000" "10" "${dataset}"
#execQuery "7"  "10000" "10" "${dataset}"
execQuery "8"  "10000" "10" "${dataset}"
execQuery "9"  "10000" "10" "${dataset}"
execQuery "10" "10000" "10" "${dataset}"
execQuery "11" "10000" "10" "${dataset}"
