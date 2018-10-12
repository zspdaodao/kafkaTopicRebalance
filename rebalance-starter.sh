#!/bin/bash

source ./what-needed.sh

echo "====》zookeeper: " $zkServer
echo "====》brokerList: " $brokerList

echo "=====================rebalance assignment configuration starting...================"

assignments=`../bin/kafka-reassign-partitions  --zookeeper $zkServer --topics-to-move-json-file $topicsToMoveFile --broker-list $brokerList --generate`

currentAssignment=`echo $assignments | awk -F 'Proposed partition reassignment configuration' '{print $2}'`

forRollBack=`echo $assignments | awk -F 'Current partition replica assignment' '{print $2}'`

echo "====》Proposed partition reassignment configuration:"
echo $currentAssignment

echo "====》Current partition replica assignment:"
echo $forRollBack

echo $currentAssignment > expand-cluster-reassignment.json

echo $forRollBack >> ./logs/save-for-roll-back.json

echo "===============================starting rebalance...================================="
echo `date '+%Y-%m-%d %H:%M:%S'`
../bin/kafka-reassign-partitions  --zookeeper $zkServer --reassignment-json-file expand-cluster-reassignment.json --execute

echo "=======================to verify the result, copy below:============================"

echo "../bin/kafka-reassign-partitions  --zookeeper $zkServer --reassignment-json-file expand-cluster-reassignment.json --verify"


