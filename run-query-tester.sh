#/bin/bash

evalCmdWithFile() {
  cmd=$1
  argfile=$2
  delim=$3
  lines=$4
  while IFS=${delim} read -ra args
  do 
    echo "args=[${args[@]}]"
    eval "$cmd" 2>/dev/null | grep "Percentile"
  done <<< "$(head -n $[lines+1] ${argfile} | tail -n $lines)"
}

# Number of times to execute the same query with the same parameters.
query_repeat_count=1

# The dataset on which this query is executing and drawing parameters from.
dataset="ldbc_snb_sf0001"

# The number of different parameter sets to evaluate from the parameter
# substitution file.
parameter_sets=1

# Delimiter in the substitution parameters file.
delim="|"

query1_cmd="./bin/QueryTester.sh query1 \${args[0]} \${args[1]} 20 --repeat ${query_repeat_count}"
query1_argfile="interactive_1_param.txt"
query2_cmd="./bin/QueryTester.sh query2 \${args[0]} \${args[1]} 20 --repeat ${query_repeat_count}"
query2_argfile="interactive_2_param.txt"
query3_cmd="./bin/QueryTester.sh query3 \${args[0]} \${args[3]} \${args[4]} \${args[1]} \${args[2]} 20 --repeat ${query_repeat_count}"
query3_argfile="interactive_3_param.txt"
query4_cmd="./bin/QueryTester.sh query4 \${args[0]} \${args[1]} \${args[2]} 10 --repeat ${query_repeat_count}"
query4_argfile="interactive_4_param.txt"
query5_cmd="./bin/QueryTester.sh query5 \${args[0]} \${args[1]} 20 --repeat ${query_repeat_count}"
query5_argfile="interactive_5_param.txt"
query6_cmd="./bin/QueryTester.sh query6 \${args[0]} \${args[1]} 10 --repeat ${query_repeat_count}"
query6_argfile="interactive_6_param.txt"
query7_cmd="./bin/QueryTester.sh query7 \${args[0]} 20 --repeat ${query_repeat_count}"
query7_argfile="interactive_7_param.txt"
query8_cmd="./bin/QueryTester.sh query8 \${args[0]} 20 --repeat ${query_repeat_count}"
query8_argfile="interactive_8_param.txt"
query9_cmd="./bin/QueryTester.sh query9 \${args[0]} \${args[1]} 20 --repeat ${query_repeat_count}"
query9_argfile="interactive_9_param.txt"
query10_cmd="./bin/QueryTester.sh query10 \${args[0]} \${args[1]} 10 --repeat ${query_repeat_count}"
query10_argfile="interactive_10_param.txt"
query11_cmd="./bin/QueryTester.sh query11 \${args[0]} \${args[1]} \${args[2]} 10 --repeat ${query_repeat_count}"
query11_argfile="interactive_11_param.txt"
query12_cmd="./bin/QueryTester.sh query12 \${args[0]} \${args[1]} 20 --repeat ${query_repeat_count}"
query12_argfile="interactive_12_param.txt"
query13_cmd="./bin/QueryTester.sh query13 \${args[0]} \${args[1]} --repeat ${query_repeat_count}"
query13_argfile="interactive_13_param.txt"
query14_cmd="./bin/QueryTester.sh query14 \${args[0]} \${args[1]} --repeat ${query_repeat_count}"
query14_argfile="interactive_14_param.txt"

echo "${query1_cmd}"
evalCmdWithFile "${query1_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query1_argfile}" "${delim}" "${parameter_sets}"
echo "${query2_cmd}"
evalCmdWithFile "${query2_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query2_argfile}" "${delim}" "${parameter_sets}"
echo "${query3_cmd}"
evalCmdWithFile "${query3_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query3_argfile}" "${delim}" "${parameter_sets}"
echo "${query4_cmd}"
evalCmdWithFile "${query4_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query4_argfile}" "${delim}" "${parameter_sets}"
echo "${query5_cmd}"
evalCmdWithFile "${query5_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query5_argfile}" "${delim}" "${parameter_sets}"
echo "${query6_cmd}"
evalCmdWithFile "${query6_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query6_argfile}" "${delim}" "${parameter_sets}"
echo "${query7_cmd}"
evalCmdWithFile "${query7_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query7_argfile}" "${delim}" "${parameter_sets}"
echo "${query8_cmd}"
evalCmdWithFile "${query8_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query8_argfile}" "${delim}" "${parameter_sets}"
echo "${query9_cmd}"
evalCmdWithFile "${query9_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query9_argfile}" "${delim}" "${parameter_sets}"
echo "${query10_cmd}"
evalCmdWithFile "${query10_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query10_argfile}" "${delim}" "${parameter_sets}"
echo "${query11_cmd}"
evalCmdWithFile "${query11_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query11_argfile}" "${delim}" "${parameter_sets}"
echo "${query12_cmd}"
evalCmdWithFile "${query12_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query12_argfile}" "${delim}" "${parameter_sets}"
echo "${query13_cmd}"
evalCmdWithFile "${query13_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query13_argfile}" "${delim}" "${parameter_sets}"
echo "${query14_cmd}"
evalCmdWithFile "${query14_cmd}" "/datasets/ldbc-snb/${dataset}/substitution_parameters/${query14_argfile}" "${delim}" "${parameter_sets}"
