#!/usr/bin/python

import sys
import re

data = []
with open(sys.argv[1], "r") as f:
  querystat = {}
  totalTraverseTime = 0
  totalEdges = 0
  totalFillPropertiesTime = 0
  totalMultiReadPropertiesTime = 0
  totalProps = 0
  totalMultiReadEdgeListTime = 0
  for line in f:
    if re.match("^cmd=\[(short)?(query[0-9]*) (.*)\]", line):
      match = re.match("^cmd=\[(short)?(query[0-9]*) (.*)\]", line)
      if bool(querystat):
        data.append(querystat)
        querystat = {}

      if match.group(1):
        querystat["queryName"] = match.group(1) + match.group(2)
      else:
        querystat["queryName"] = match.group(2)

      querystat["args"] = match.group(3)
        
      querystat["totalTraverseTime"] = totalTraverseTime
      querystat["totalEdges"] = totalEdges
      querystat["totalFillPropertiesTime"] = totalFillPropertiesTime
      querystat["totalMultiReadPropertiesTime"] = totalMultiReadPropertiesTime
      querystat["totalProps"] = totalProps
      querystat["totalMultiReadEdgeListTime"] = totalMultiReadEdgeListTime

      totalTraverseTime = 0
      totalEdges = 0
      totalFillPropertiesTime = 0
      totalProps = 0
      totalMultiReadPropertiesTime = 0
      totalMultiReadEdgeListTime = 0
    elif re.match("^cmd=\[(update[0-9]*) (.*)\]", line):
      match = re.match("^cmd=\[(update[0-9]*) (.*)\]", line)
      if bool(querystat):
        data.append(querystat)
        querystat = {}

      querystat["queryName"] = match.group(1)
      querystat["args"] = match.group(2)

      querystat["totalTraverseTime"] = totalTraverseTime
      querystat["totalEdges"] = totalEdges
      querystat["totalFillPropertiesTime"] = totalFillPropertiesTime
      querystat["totalMultiReadPropertiesTime"] = totalMultiReadPropertiesTime
      querystat["totalProps"] = totalProps
      querystat["totalMultiReadEdgeListTime"] = totalMultiReadEdgeListTime

      totalTraverseTime = 0
      totalEdges = 0
      totalFillPropertiesTime = 0
      totalProps = 0
      totalMultiReadPropertiesTime = 0
      totalMultiReadEdgeListTime = 0
    elif re.match("^\s*([0-9]*)th\s+Percentile:\s+([0-9]*)", line):
      match = re.match("^\s*([0-9]*)th\s+Percentile:\s+([0-9]*)", line)
      querystat[match.group(1)] = match.group(2)
    elif re.match("\s*(Min|Max|Mean|Count):\s+([0-9]*)", line):
      match = re.match("\s*(Min|Max|Mean|Count):\s+([0-9]*)", line)
      querystat[match.group(1)] = match.group(2)
    elif re.match("^Graph.fillProperties\(\): requests: ([0-9]*), multiread_properties: time: ([0-9]*) us$", line):
      match = re.match("^Graph.fillProperties\(\): requests: ([0-9]*), multiread_properties: time: ([0-9]*) us$", line)
      properties = int(match.group(1))
      multiReadPropertiesTime = int(match.group(2))
      totalProps += properties
      totalMultiReadPropertiesTime += multiReadPropertiesTime
    elif re.match("^EdgeList.batchRead\(\): multiread_edgelist: time: ([0-9]*) us", line):
      match = re.match("^EdgeList.batchRead\(\): multiread_edgelist: time: ([0-9]*) us", line)
      multiReadEdgeListTime = int(match.group(1))
      totalMultiReadEdgeListTime += multiReadEdgeListTime
    elif re.match("^Graph.traverse\(\): base vertices: ([0-9]*), total edges: ([0-9]*), unique neighbors: ([0-9]*), parse properties: (true|false), total time: ([0-9]*) us$", line):
      match = re.match("^Graph.traverse\(\): base vertices: ([0-9]*), total edges: ([0-9]*), unique neighbors: ([0-9]*), parse properties: (true|false), total time: ([0-9]*) us$", line)
      traverseBaseVertices = int(match.group(1))
      traverseTotalEdges = int(match.group(2))
      traverseUniqNeighbors = int(match.group(3))
      traverseParseProps = match.group(4)
      traverseTime = int(match.group(5))
      totalEdges += traverseTotalEdges
      totalTraverseTime += traverseTime
    elif re.match("^Graph.fillProperties\(\): total time: ([0-9]*) us$", line):
      match = re.match("^Graph.fillProperties\(\): total time: ([0-9]*) us$", line)
      fillPropertiesTime = int(match.group(1))
      totalFillPropertiesTime += fillPropertiesTime

  if bool(querystat):
    data.append(querystat)
    querystat = {}

# print data
# with open("debug-output.csv", "w") as f:
#  f.write("QueryName,MultiReadTime,TraverseTime,QueryTime\n")
  print "QueryName,MultiReadPropertiesTime,MultiReadEdgeListTime,TraverseTime,TotalEdges,FillPropertiesTime,TotalProps,QueryTime"
  for querystats in data:
#      f.write(queryname + "," + str(querystats["totalMultiReadTime"]) + "," + str(querystats["totalTraverseTime"]) + "," + querystats["50"] + "\n")
    print querystats["queryName"] + "," + str(querystats["totalMultiReadPropertiesTime"]) + "," + str(querystats["totalMultiReadEdgeListTime"]) + "," + str(querystats["totalTraverseTime"]) + "," + str(querystats["totalEdges"]) + "," + str(querystats["totalFillPropertiesTime"]) + "," + str(querystats["totalProps"]) + "," + querystats["50"]
#  with open(queryname + "-50th.csv", "w") as f:
#    for querystats in data[queryname]:
##      print querystats["50"],
#      f.write(querystats["50"] + "\n")

#    print
