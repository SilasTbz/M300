#!/bin/bash

#pfad zum ordner "LB3" aus dem geklonten repository
CLONEPATH="/root/M300_repo"
MASTERNODE_NAME="master-node"
ANSIBLE_USER_PASSWD="R00t"
POD_NET_CIDR="10.244.0.0/16"

function print_log {
    LOGTYPE=$1;
    LOGTEXT=$2;

    case $LOGTYPE in
        process)
            printf "\033[34m [*] ${LOGTEXT}\033[0m \n"
            ;;
        info)
            printf "\033[36m [?] ${LOGTEXT}\033[0m \n"
            ;;
        success)
            printf "\033[32m [+] ${LOGTEXT}\033[0m \n"
            ;;
        error)
            printf "\033[31m [-] ${LOGTEXT}\033[0m \n"
            ;;
    esac
}

print_log process "check if user is 'root'"
if (( $EUID != 0 )); then
    print_log info "user is NOT 'root' !"
    print_log process "switch to user 'root'"
    sudo su -
fi

if (( $EUID == 0 )); then
    print_log success "user IS now 'root'"
    print_log process "updating system"
    apt update -y && apt full-upgrade -y
    print_log process "installing git"
    apt install git -y
    print_log process "install dependencies"
    apt install ansible sshpass -y
    print_log process "update system"
    apt update -y && apt full-upgrade -y
    print_log process "cloning repo"
    git clone https://github.com/slowloris-coding/M300.git ${CLONEPATH}
    print_log process "create folder /root/kube-cluster"
    mkdir ~/kube-cluster
    print_log process "copy all needed files from cloned repo-folder"
    cp ${CLONEPATH}/LB3/inventories/hosts ~/kube-cluster/hosts
    cp ${CLONEPATH}/LB3/playbooks/01_initial.yml ~/kube-cluster/01_initial.yml
    cp ${CLONEPATH}/LB3/playbooks/02_kube-dependencies.yml ~/kube-cluster/02_kube-dependencies.yml
    cp ${CLONEPATH}/LB3/playbooks/03_master.yml ~/kube-cluster/hosts 03_master.yml
    cp ${CLONEPATH}/LB3/playbooks/04_workers.yml ~/kube-cluster/hosts 04_workers.yml
    print_log process "disable swap"
    swapoff -a
    print_log process "run initial playbook"
    ansible-playbook -i hosts ~/kube-cluster/01_initial.yml --extra-vars "ansible_password=${ANSIBLE_USER_PASSWD}"
    print_log process "run kubectl dependencies install"
    ansible-playbook -i hosts ~/kube-cluster/02_kube-dependencies.yml --extra-vars "ansible_password=${ANSIBLE_USER_PASSWD}"
    print_log info "FOR BUG FIX PURPOSE: running 'kubeadm init' outside of the playbook"
    kubeadm init --pod-network-cidr=${POD_NET_CIDR} >> cluster_initialized.txt
    print_log process "Install master-node"
    ansible-playbook -i hosts ~/kube-cluster/03_master.yml --extra-vars "ansible_password=${ANSIBLE_USER_PASSWD}"
    print_log process "Install worker-nodes"
    ansible-playbook -i hosts ~/kube-cluster/04_workers.yml --extra-vars "ansible_password=${ANSIBLE_USER_PASSWD}"
else
    print_log error "user IS NOT 'root' --> exit skript without doing anything"
fi