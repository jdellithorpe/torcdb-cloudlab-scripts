#!/bin/bash

file=$1
LdbcQueryCount[1]=$(( $(cat $file | grep "LdbcQuery1{" | wc -l) / 1 ))
LdbcQueryCount[2]=$(( $(cat $file | grep "LdbcQuery2{" | wc -l) / 1 ))
LdbcQueryCount[3]=$(( $(cat $file | grep "LdbcQuery3{" | wc -l) / 1 ))
LdbcQueryCount[4]=$(( $(cat $file | grep "LdbcQuery4{" | wc -l) / 1 ))
LdbcQueryCount[5]=$(( $(cat $file | grep "LdbcQuery5{" | wc -l) / 1 ))
LdbcQueryCount[6]=$(( $(cat $file | grep "LdbcQuery6{" | wc -l) / 1 ))
LdbcQueryCount[7]=$(( $(cat $file | grep "LdbcQuery7{" | wc -l) / 1 ))
LdbcQueryCount[8]=$(( $(cat $file | grep "LdbcQuery8{" | wc -l) / 1 ))
LdbcQueryCount[9]=$(( $(cat $file | grep "LdbcQuery9{" | wc -l) / 1 ))
LdbcQueryCount[10]=$(( $(cat $file | grep "LdbcQuery10{" | wc -l) / 1 ))
LdbcQueryCount[11]=$(( $(cat $file | grep "LdbcQuery11{" | wc -l) / 1 ))
LdbcQueryCount[12]=$(( $(cat $file | grep "LdbcQuery12{" | wc -l) / 1 ))
LdbcQueryCount[13]=$(( $(cat $file | grep "LdbcQuery13{" | wc -l) / 1 ))
LdbcQueryCount[14]=$(( $(cat $file | grep "LdbcQuery14{" | wc -l) / 1 ))

LdbcShortQueryCount[1]=$(( $(cat $file | grep "LdbcShortQuery1" | wc -l) / 1 ))
LdbcShortQueryCount[2]=$(( $(cat $file | grep "LdbcShortQuery2" | wc -l) / 1 ))
LdbcShortQueryCount[3]=$(( $(cat $file | grep "LdbcShortQuery3" | wc -l) / 1 ))
LdbcShortQueryCount[4]=$(( $(cat $file | grep "LdbcShortQuery4" | wc -l) / 1 ))
LdbcShortQueryCount[5]=$(( $(cat $file | grep "LdbcShortQuery5" | wc -l) / 1 ))
LdbcShortQueryCount[6]=$(( $(cat $file | grep "LdbcShortQuery6" | wc -l) / 1 ))
LdbcShortQueryCount[7]=$(( $(cat $file | grep "LdbcShortQuery7" | wc -l) / 1 ))

LdbcUpdateCount[1]=$(( $(cat $file | grep "LdbcUpdate1" | wc -l) / 1 ))
LdbcUpdateCount[2]=$(( $(cat $file | grep "LdbcUpdate2" | wc -l) / 1 ))
LdbcUpdateCount[3]=$(( $(cat $file | grep "LdbcUpdate3" | wc -l) / 1 ))
LdbcUpdateCount[4]=$(( $(cat $file | grep "LdbcUpdate4" | wc -l) / 1 ))
LdbcUpdateCount[5]=$(( $(cat $file | grep "LdbcUpdate5" | wc -l) / 1 ))
LdbcUpdateCount[6]=$(( $(cat $file | grep "LdbcUpdate6" | wc -l) / 1 ))
LdbcUpdateCount[7]=$(( $(cat $file | grep "LdbcUpdate7" | wc -l) / 1 ))
LdbcUpdateCount[8]=$(( $(cat $file | grep "LdbcUpdate8" | wc -l) / 1 ))

grandTotal=0

totalCount=0
for (( i = 1; i < 15; i++))
do
  echo "LdbcQuery"$i" Count: "${LdbcQueryCount[${i}]}
  (( totalCount += LdbcQueryCount[${i}] ))
done
(( grandTotal += totalCount ))

echo "Total LdbcQuery Count: "$totalCount
echo ""

totalCount=0
for (( i = 1; i < 8; i++))
do
  echo "LdbcShortQuery"$i" Count: "${LdbcShortQueryCount[${i}]}
  (( totalCount += LdbcShortQueryCount[${i}] ))
done
(( grandTotal += totalCount ))

echo "Total LdbcShortQuery Count: "$totalCount
echo ""

totalCount=0
for (( i = 1; i < 9; i++))
do
  echo "LdbcUpdate"$i" Count: "${LdbcUpdateCount[${i}]}
  (( totalCount += LdbcUpdateCount[${i}] ))
done
(( grandTotal += totalCount ))

echo "Total LdbcUpdate Count: "$totalCount
echo ""

echo "Grand Total: "$grandTotal
