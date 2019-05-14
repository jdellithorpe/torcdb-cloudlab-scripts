#!/usr/bin/python

import sys
import re

data = {}
with open(sys.argv[1], "r") as f:
  queryname = ""
  queryargs = ""
  querystat = {}
  for line in f:
    match = re.match("^cmd=\[(query[0-9]*) (.*)\]", line)
    if match:
      if bool(querystat):
        if queryname in data:
          data[queryname].append(querystat)
        else:
          data[queryname] = [querystat]
        querystat = {}

      queryname = match.group(1)
      queryargs = match.group(2)
      querystat["args"] = queryargs

    match = re.match("^\s*([0-9]*)th\s+Percentile:\s+([0-9]*)", line)
    if match:
      querystat[match.group(1)] = match.group(2)
    
    match = re.match("\s*(Min|Max|Mean|Count):\s+([0-9]*)", line)
    if match:
      querystat[match.group(1)] = match.group(2)

#print data
for queryname in data:
  count = 0
  for querystats in data[queryname]:
    
    print("%s %s %s %s %s %s" % (
      queryname + "_" + str(count), 
      int(querystats["Min"]),
      int(querystats["50"]) - int(querystats["Min"]),
      int(querystats["90"]) - int(querystats["50"]),
      int(querystats["99"]) - int(querystats["90"]),
      int(querystats["Max"]) - int(querystats["99"])))
    count += 1
