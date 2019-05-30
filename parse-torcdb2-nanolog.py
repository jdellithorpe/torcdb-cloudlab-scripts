#!/usr/bin/python

import sys
import re
import json

data = {}
with open(sys.argv[1], "r") as f:
  queryName = ""
  queryOpList = []
  queryNumber = 1
  operationCount = 0
  totalBytesRead = 0
  totalObjectsRequested = 0
  totalObjectsExist = 0
  prevOperationCount = 0
  prevTotalBytesRead = 0
  prevTotalObjectsRequested = 0
  prevTotalObjectsExist = 0
  print("QueryName,QueryNumber,OperationCount,TotalOperationTime,TotalBytesRead,TotalObjectsRequested,TotalObjectsExist")
  for line in f:
    match = re.match(".*(Ldbc[a-z|A-Z]+[0-9]+)\s+Start", line)
    if match:
      if bool(queryOpList):
        prevOperationCount = operationCount
        prevTotalBytesRead = totalBytesRead
        prevTotalObjectsRequested = totalObjectsRequested
        prevTotalObjectsExist = totalObjectsExist

        operationCount = len(queryOpList)
        totalOperationTime = 0
        totalBytesRead = 0
        totalObjectsRequested = 0
        totalObjectsExist = 0
        for op in queryOpList:
          totalOperationTime += op["elapsedTime"]
          totalBytesRead += op["totalLen"]
          totalObjectsRequested += op["numRequests"]
          totalObjectsExist += op["totalOK"]
        
        if not (operationCount == prevOperationCount and totalBytesRead ==
            prevTotalBytesRead and totalObjectsRequested == prevTotalObjectsRequested and
            totalObjectsExist == prevTotalObjectsExist):
          queryNumber = 1
        else:
          queryNumber += 1
      
        print("%s,%d,%d,%d,%d,%d,%d" % (queryName, queryNumber, operationCount, totalOperationTime, totalBytesRead, totalObjectsRequested, totalObjectsExist))

#        if queryName in data:
#          data[queryName].append(queryOpList)
#        else:
#          data[queryName] = [queryOpList]

      queryOpList = []
      queryName = match.group(1)

    match = re.match(".*({.*})", line)
    if match:
      queryOpList.append(json.loads(match.group(1)))

  if queryName != "" and bool(queryOpList):
    prevOperationCount = operationCount
    prevTotalBytesRead = totalBytesRead
    prevTotalObjectsRequested = totalObjectsRequested
    prevTotalObjectsExist = totalObjectsExist

    operationCount = len(queryOpList)
    totalOperationTime = 0
    totalBytesRead = 0
    totalObjectsRequested = 0
    totalObjectsExist = 0
    for op in queryOpList:
      totalOperationTime += op["elapsedTime"]
      totalBytesRead += op["totalLen"]
      totalObjectsRequested += op["numRequests"]
      totalObjectsExist += op["totalOK"]
    
    if not (operationCount == prevOperationCount and totalBytesRead ==
        prevTotalBytesRead and totalObjectsRequested == prevTotalObjectsRequested and
        totalObjectsExist == prevTotalObjectsExist):
      queryNumber = 1
    else:
      queryNumber += 1
    
    print("%s,%d,%d,%d,%d,%d,%d" % (queryName, queryNumber, operationCount, totalOperationTime, totalBytesRead, totalObjectsRequested, totalObjectsExist))
    
#    if queryName in data:
#      data[queryName].append(queryOpList)
#    else:
#      data[queryName] = [queryOpList]

#print("QueryName,QueryNumber,OperationCount,TotalOperationTime,TotalBytesRead,TotalObjectsRequested,TotalObjectsExist")
#for queryName in data:
#  queryNumber = 1
#  for queryOpList in data[queryName]:
#    operationCount = len(queryOpList)
#    totalOperationTime = 0
#    totalBytesRead = 0
#    totalObjectsRequested = 0
#    totalObjectsExist = 0
#    for op in queryOpList:
#      totalOperationTime += op["elapsedTime"]
#      totalBytesRead += op["totalLen"]
#      totalObjectsRequested += op["numRequests"]
#      totalObjectsExist += op["totalOK"]
#    print("%s,%d,%d,%d,%d,%d,%d" % (queryName, queryNumber, operationCount, totalOperationTime, totalBytesRead, totalObjectsRequested, totalObjectsExist))
#
#    queryNumber += 1
