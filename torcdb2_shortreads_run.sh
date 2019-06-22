#!/bin/bash

ramcloudBranch=torcdb-experiments
graphName=ldbc_snb_sf0100
querySet=${graphName}_shortquery1-2-3_persons
time sudo LD_LIBRARY_PATH=${HOME}/RAMCloud/obj.${ramcloudBranch} mvn exec:exec -Dexec.qtargs="--script ${querySet}.qts" |& tee ${querySet}.out
${HOME}/torcdb-cloudlab-scripts/parse-query-tester-output-50th.py ${querySet}.out
for i in {1..3}; do mv shortquery${i}-50th.csv torcdb2_shortquery${i}_persons-50th.csv; done
mv latency.csv ${querySet}_latency.csv
mv latency_stats.csv ${querySet}_latency_stats.csv

querySet=${graphName}_shortquery4-5-6-7_comments
time sudo LD_LIBRARY_PATH=${HOME}/RAMCloud/obj.${ramcloudBranch} mvn exec:exec -Dexec.qtargs="--script ${querySet}.qts" |& tee ${querySet}.out
${HOME}/torcdb-cloudlab-scripts/parse-query-tester-output-50th.py ${querySet}.out
for i in {4..7}; do mv shortquery${i}-50th.csv torcdb2_shortquery${i}_comments-50th.csv; done
mv latency.csv ${querySet}_latency.csv
mv latency_stats.csv ${querySet}_latency_stats.csv

querySet=${graphName}_shortquery4-5-6-7_posts
time sudo LD_LIBRARY_PATH=${HOME}/RAMCloud/obj.${ramcloudBranch} mvn exec:exec -Dexec.qtargs="--script ${querySet}.qts" |& tee ${querySet}.out
${HOME}/torcdb-cloudlab-scripts/parse-query-tester-output-50th.py ${querySet}.out
for i in {4..7}; do mv shortquery${i}-50th.csv torcdb2_shortquery${i}_posts-50th.csv; done
mv latency.csv ${querySet}_latency.csv
mv latency_stats.csv ${querySet}_latency_stats.csv
