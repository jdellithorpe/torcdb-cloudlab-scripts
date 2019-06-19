#!/bin/bash

time sudo LD_LIBRARY_PATH=/shome/jde/RAMCloud/obj.torcdb-experiments mvn exec:exec -Dexec.qtargs="--script ldbc_snb_sf0100_shortquery1-2-3_persons.qts" |& tee ldbc_snb_sf0100_shortquery1-2-3_persons.out
time sudo LD_LIBRARY_PATH=/shome/jde/RAMCloud/obj.torcdb-experiments mvn exec:exec -Dexec.qtargs="--script ldbc_snb_sf0100_shortquery4-5-6-7_comments.qts" |& tee ldbc_snb_sf0100_shortquery4-5-6-7_comments.out
time sudo LD_LIBRARY_PATH=/shome/jde/RAMCloud/obj.torcdb-experiments mvn exec:exec -Dexec.qtargs="--script ldbc_snb_sf0100_shortquery4-5-6-7_posts.qts" |& tee ldbc_snb_sf0100_shortquery4-5-6-7_posts.out
