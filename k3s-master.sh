#!/bin/bash
source ./function.sh

logFile=/tmp/log-k3s-master.txt

createLog $logFile

messageInitMaster 5

command='net update docker dockerUser keyboard timezone swap gpuMem featuresContainer configNet k3sMaster'

for i in $command ; do
  if [ -f $logFile ]; then
    $i $logFile
  else
    $i "/dev/null"
  fi
done

messageEnd