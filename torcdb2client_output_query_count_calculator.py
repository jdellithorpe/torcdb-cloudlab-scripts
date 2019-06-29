#!/usr/bin/python

import sys

updateCount = int(sys.argv[1])

LdbcQueryCount = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
LdbcQueryCount[1] = updateCount / 26
LdbcQueryCount[2] = updateCount / 37
LdbcQueryCount[3] = updateCount / 123
LdbcQueryCount[4] = updateCount / 36
LdbcQueryCount[5] = updateCount / 78
LdbcQueryCount[6] = updateCount / 434
LdbcQueryCount[7] = updateCount / 38
LdbcQueryCount[8] = updateCount / 5
LdbcQueryCount[9] = updateCount / 527
LdbcQueryCount[10] = updateCount / 40
LdbcQueryCount[11] = updateCount / 22
LdbcQueryCount[12] = updateCount / 44
LdbcQueryCount[13] = updateCount / 19
LdbcQueryCount[14] = updateCount / 49

print("LdbcQuery1 Count: %d" % LdbcQueryCount[1])
print("LdbcQuery2 Count: %d" % LdbcQueryCount[2])
print("LdbcQuery3 Count: %d" % LdbcQueryCount[3])
print("LdbcQuery4 Count: %d" % LdbcQueryCount[4])
print("LdbcQuery5 Count: %d" % LdbcQueryCount[5])
print("LdbcQuery6 Count: %d" % LdbcQueryCount[6])
print("LdbcQuery7 Count: %d" % LdbcQueryCount[7])
print("LdbcQuery8 Count: %d" % LdbcQueryCount[8])
print("LdbcQuery9 Count: %d" % LdbcQueryCount[9])
print("LdbcQuery10 Count: %d" % LdbcQueryCount[10])
print("LdbcQuery11 Count: %d" % LdbcQueryCount[11])
print("LdbcQuery12 Count: %d" % LdbcQueryCount[12])
print("LdbcQuery13 Count: %d" % LdbcQueryCount[13])
print("LdbcQuery14 Count: %d" % LdbcQueryCount[14])

totalCount = 0
for i in range(1,15):
  totalCount += LdbcQueryCount[i]

print("Total Count: %d" % totalCount)
