#!/bin/bash
source ./function.sh

logFile=/tmp/log-k3s-agent.txt

createLog $logFile

messageInitAgent 5

command='net update docker dockerUser keyboard timezone swap gpuMem featuresContainer configNet k3sAgent'

for i in $command ; do
  if [ -f $logFile ]; then
    $i $logFile
  else
    $i "/dev/null"
  fi
done

messageEnd