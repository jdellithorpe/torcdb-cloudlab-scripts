
all: repartition-ldbc-snb-dataset-files

repartition-ldbc-snb-dataset-files: repartition-ldbc-snb-dataset-files.cc
	g++ -std=c++11 -o $@ $^
