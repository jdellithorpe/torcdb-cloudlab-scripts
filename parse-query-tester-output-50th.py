#!/usr/bin/python

import sys
import re

data = {}
with open(sys.argv[1], "r") as f:
  queryname = ""
  queryargs = ""
  querystat = {}
  for line in f:
    match = re.match("^cmd=\[(short)?(query[0-9]*) (.*)\]", line)
    if match:
      if bool(querystat):
        if queryname in data:
          data[queryname].append(querystat)
        else:
          data[queryname] = [querystat]
        querystat = {}

      if match.group(1):
        queryname = match.group(1) + match.group(2)
      else:
        queryname = match.group(2)
      
      queryargs = match.group(3)
      querystat["args"] = queryargs

    match = re.match("^\s*([0-9]*)th\s+Percentile:\s+([0-9]*)", line)
    if match:
      querystat[match.group(1)] = match.group(2)
    
    match = re.match("\s*(Min|Max|Mean|Count):\s+([0-9]*)", line)
    if match:
      querystat[match.group(1)] = match.group(2)
      
  if bool(querystat):
    if queryname in data:
      data[queryname].append(querystat)
    else:
      data[queryname] = [querystat]
    querystat = {}

#print data
for queryname in data:
#  print queryname,

  with open(queryname + "-50th.csv", "w") as f:
    for querystats in data[queryname]:
#      print querystats["50"],
      f.write(querystats["50"] + "\n")

#    print
