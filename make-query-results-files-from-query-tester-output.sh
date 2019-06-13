#!/bin/bash

for i in {1..14}; do cat query_results_gathering_script_sf0001.out | grep "^LdbcQuery${i}Result{.*}\|cmd=\[query${i} " > query${i}_ldbc_snb_sf0001_results.txt; done
for i in {1..14}; do sed -i 's/ --timeUnits=MICROSECONDS//' query${i}_ldbc_snb_sf0001_results.txt; done
