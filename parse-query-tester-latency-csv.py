#!/usr/bin/python

import sys
import re

data = {}
with open(sys.argv[1], "r") as f:
  queryname = ""
  queryargs = ""
  querystat = {}

  prevqueryname = ""
  queryinstances = 0
  queryrep = 0
  for line in f:
    lineparts = line.split(",")
    queryname = lineparts[0]
    
    if queryname != prevqueryname:
      # On to a new query type
      if queryinstances > 0:
        print(prevqueryname + ": instances: " + str(queryinstances) + " repeatCount: " + str(queryrep))
      queryinstances = 0
    
    queryrep = int(lineparts[1])
    querylat = int(lineparts[2])
  
    if queryrep == 1:
      queryinstances += 1

    prevqueryname = queryname
      
  if queryinstances > 0:
    print(prevqueryname + ": instances: " + str(queryinstances) + " repeatCount: " + str(queryrep))
