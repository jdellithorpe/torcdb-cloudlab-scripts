#!/usr/bin/python3

import sys
import re
import json

# List of stats we will collect
statList = ["Query", 
            "QueryTime", 
            "TravTime", 
            "TravReduceTime", 
            "TravEstLckWaitTime", 
            "MREdgesTime", 
            "PropsTime", 
            "PropsReduceTime", 
            "PropsEstLckWaitTime", 
            "MRPropsTime", 
            "TotalEdges", 
            "TotalProps"]

# Print the header
for stat in statList:
  print(stat, end=",")
print("")

with open(sys.argv[1], "r") as f:
  queryStats = {}
  queryLogMsgList = []
  for line in f:
    if re.match("^({.*})$", line):
      match = re.match("^({.*})$", line)
      queryLogMsgList.append(json.loads(match.group(1)))
    elif re.match("^cmd=\[(short)?((query|update)[0-9]*) (.*)\]", line):
      match = re.match("^cmd=\[(short)?((query|update)[0-9]*) (.*)\]", line)

      if match.group(1):
        queryStats["name"] = match.group(1) + match.group(2)
      else:
        queryStats["name"] = match.group(2)

      queryStats["args"] = match.group(3)
    elif re.match("\s*(Min|Max|Mean|Count):\s+([0-9]*)", line):
      match = re.match("\s*(Min|Max|Mean|Count):\s+([0-9]*)", line)
      queryStats[match.group(1)] = match.group(2)
    elif re.match("^\s*([0-9]*)th\s+Percentile:\s+([0-9]*)", line):
      match = re.match("^\s*([0-9]*)th\s+Percentile:\s+([0-9]*)", line)
      queryStats[match.group(1)] = match.group(2)
      # Hit the last line of output for this query (besides results).
      if match.group(1) == "99":
        # Create value map and prepare to fill it
        statMap = {}
        for stat in statList:
          if stat == "Query":
            statMap[stat] = "NA"
          else:
            statMap[stat] = 0

        statMap["Query"] = queryStats["name"]
        statMap["QueryTime"] = queryStats["50"]
    
        # Let's calculate total trav time:
        for logMsg in queryLogMsgList:
          if logMsg["tag"] == "Graph.traverse()":
            statMap["TravTime"] += logMsg["time"]
          elif logMsg["tag"] == "EdgeList.batchReadMultiThreaded()":
            statMap["TravReduceTime"] += logMsg["reduceTime"]
          elif logMsg["tag"] == "EdgeList.batchReadThread()":
            statMap["MREdgesTime"] += logMsg["totalReadTime"]
            statMap["TotalEdges"] += logMsg["totalEdges"]
          elif logMsg["tag"] == "Graph.getProperties()":
            statMap["PropsTime"] += logMsg["time"]
          elif logMsg["tag"] == "Graph.getPropertiesMultiThreaded()":
            statMap["PropsReduceTime"] += logMsg["reduceTime"]
          elif logMsg["tag"] == "Graph.getPropertiesThread()":
            statMap["MRPropsTime"] += logMsg["totalReadTime"]       
            statMap["TotalProps"] += logMsg["totalRequests"]
        
        for stat in statList:
          print(statMap[stat], end=",")
        print("")

        queryStats = {}
        queryLogMsgList = []
