#!/bin/bash

#pfad zum ordner "LB3" aus dem geklonten repository
CLONEPATH=""

printf "(*) check if user is 'root'\n"
if (( $EUID != 0 )); then
    printf "(?) user is NOT 'root' !\n"
    printf "(*) switch to user 'root'\n"
    sudo su -
fi

if (( $EUID == 0 )); then
    printf "(+) user IS now 'root' \n"
    printf "(*) create folder /root/kube-cluster \n"
    mkdir ~/kube-cluster
    cp ${CLONEPATH}/inventory/hosts ~/kube-cluster/hosts

else
    printf "(!) user IS NOT 'root' --> exit skript without doing anything \n"
fi