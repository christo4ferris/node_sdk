#!/bin/sh

CORE_CHAINCODE_ID_NAME=mycc CORE_PEER_ADDRESS=peer:7051 ./chaincode_example02 &> logs.txt &
PID=$!
node app
kill $PID

