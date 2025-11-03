#!/bin/bash

ROLE=$1
NETWORK_PREFIX=$2
USER="anahua"
PASSWORD="Upt2025"

echo -e "\n=========================================== controller.sh ===========================================\n"

NODES=(
    "${NETWORK_PREFIX}.101"
    "${NETWORK_PREFIX}.102"
    "${NETWORK_PREFIX}.103"
    "${NETWORK_PREFIX}.104"
    "${NETWORK_PREFIX}.105"
    "${NETWORK_PREFIX}.106"
    "${NETWORK_PREFIX}.107"
    "${NETWORK_PREFIX}.108"
    "${NETWORK_PREFIX}.109"
    "${NETWORK_PREFIX}.110"
)

apt update

apt install -y ansible sshpass

sudo -u $USER ssh-keygen -t rsa -f /home/$USER/.ssh/id_rsa -N ""

for NODE in "${NODES[@]}"; do
    cat /home/$USER/.ssh/id_rsa.pub | sudo -u $USER sshpass -p $PASSWORD ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no $USER@$NODE "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
done

cd /tmp/ansible/
sudo -u $USER ansible-playbook playbook.yml -u $USER
