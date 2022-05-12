#!/bin/bash

#pfad zum ordner "LB3" aus dem geklonten repository
CLONEPATH="/root/M300_repo"
MASTERNODE_NAME="master-node"

function write_log {
    LOGTYPE=$1
    LOGTEXT=$2
    COLORNUM=0

    case $LOGTYPE in
        process)
            $COLORNUM
            ;;
    esac
}

printf "(*) check if user is 'root'\n"
if (( $EUID != 0 )); then
    printf "(?) user is NOT 'root' !\n"
    printf "(*) switch to user 'root'\n"
    sudo su -
fi

if (( $EUID == 0 )); then
    printf "(+) user IS now 'root' \n"
    printf "(*) updating system \n"
    apt update -y && apt full-upgrade -y
    printf "(*) installing git \n"
    apt install git -y
    printf "(*) cloning repo \n"
    git clone https://github.com/slowloris-coding/M300.git ${CLONEPATH}
    printf "(*) create folder /root/kube-cluster \n"
    mkdir ~/kube-cluster

    cp ${CLONEPATH}/LB3/inventories/hosts ~/kube-cluster/hosts
else
    printf "(!) user IS NOT 'root' --> exit skript without doing anything \n"
fi