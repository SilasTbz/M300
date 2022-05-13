#!/bin/bash

FIRSTNAME=$1
LASTNAME=$2
OUTPUTFOLDER=$3

OUTPUTFILE="${OUTPUTFOLDER}/lb3_${FIRSTNAME}_${LASTNAME}.txt"

rm $OUTPUTFILE
touch $OUTPUTFILE

echo "[COMMAND]> \"kubectl describe nodes | grep ID:\"" >> $OUTPUTFILE
kubectl describe nodes | grep ID: >> $OUTPUTFILE
echo "\n\n" >> $OUTPUTFILE

echo "[COMMAND]> \"kubectl get node -o wide\"" >> $OUTPUTFILE
kubectl get node -o wide >> $OUTPUTFILE
echo "\n\n" >> $OUTPUTFILE

echo "[COMMAND]> \"kubectl get pod --all-namespaces\"" >> $OUTPUTFILE
kubectl get pod --all-namespaces >> $OUTPUTFILE
echo "\n\n" >> $OUTPUTFILE

echo "[COMMAND]> \"kubectl get service --all-namespaces\"" >> $OUTPUTFILE
kubectl get service --all-namespaces >> $OUTPUTFILE
echo "\n\n" >> $OUTPUTFILE

echo "[COMMAND]> \"kubectl get deployments.apps\"" >> $OUTPUTFILE
kubectl get deployments.apps >> $OUTPUTFILE
echo "\n\n" >> $OUTPUTFILE

echo "[COMMAND]> \"kubectl get persistentvolume\"" >> $OUTPUTFILE
kubectl get persistentvolume >> $OUTPUTFILE
echo "\n\n" >> $OUTPUTFILE