#!/bin/bash

if [[ $# != 1 ]]
then
  echo "Parse the output of QueryTester to produce query\${i}_results.txt for"
  echo "i in {1..14}"
  echo ""
  echo "Usage: make-query-results-files-from-query-tester-output.sh FILE"
  echo "  FILE             QueryTester output to parse."

  exit
fi

INPUT_FILE=$1

for i in {1..14}; do cat ${INPUT_FILE} | grep "^LdbcQuery${i}Result{.*}\|^LdbcQuery${i}{.*}" > query${i}_results.txt; done
