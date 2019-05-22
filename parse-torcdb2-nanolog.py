#!/usr/bin/python

import sys
import re
import json

data = {}
with open(sys.argv[1], "r") as f:
  queryname = ""
  queryargs = ""
  querystat = {}
  queryrcops = []
  for line in f:
    match = re.match(".*(Ldbc[a-z|A-Z]+[0-9]+)\s+Start", line)
    if match:
      if bool(queryrcops):
        if queryname in data:
          data[queryname].append(queryrcops)
        else:
          data[queryname] = [queryrcops]
        queryrcops = []

      queryname = match.group(1)

    match = re.match(".*({.*})", line)
    if match:
      queryrcops.append(json.loads(match.group(1)))

  if queryname != "" and bool(queryrcops):
    if queryname in data:
      data[queryname].append(queryrcops)
    else:
      data[queryname] = [queryrcops]

#print data
print("queryname,totalOps,totalBytesRead,totalObjectsRequested,totalObjectsRead")
for queryname in data:
  with open(queryname + "-basicstats.csv", "w") as f:
    for queryrcops in data[queryname]:
      totalOps = len(queryrcops)
      totalBytesRead = 0
      totalObjectsRequested = 0
      totalObjectsRead = 0
      for rcop in queryrcops:
        totalBytesRead += rcop["totalLen"]
        totalObjectsRequested += rcop["numRequests"]
        totalObjectsRead += rcop["totalOK"]
      print("%s,%d,%d,%d,%d\n" % (queryname, totalOps, totalBytesRead, totalObjectsRequested, totalObjectsRead))
      f.write("%d,%d,%d,%d\n" % (totalOps, totalBytesRead, totalObjectsRequested, totalObjectsRead))

    print
