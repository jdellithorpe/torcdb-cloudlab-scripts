#!/bin/bash

ramcloudBranch=torcdb-experiments
graphName=ldbc_snb_sf0100
querySet=${graphName}_complexquery-all
time sudo LD_LIBRARY_PATH=${HOME}/RAMCloud/obj.${ramcloudBranch} mvn exec:exec -Dexec.qtargs="--script ${querySet}.qts" |& tee ${querySet}.out
${HOME}/torcdb-cloudlab-scripts/parse-query-tester-output-50th.py ${querySet}.out
for i in {1..14}; do mv query${i}-50th.csv torcdb2_query${i}-50th.csv; done
mv latency.csv ${querySet}_latency.csv
mv latency_stats.csv ${querySet}_latency_stats.csv
