#!/bin/bash

ROLE=$1
# HOSTNAME=$2

echo -e "\n=========================================== Inicio: $(whoami) ==========================================="

# Cambiar al usuario root
# sudo su -

# Llamar al script config.sh
bash /vagrant/scripts/config.sh

# Llamar al script docker.sh para instalar Docker
# bash /vagrant/scripts/docker.sh

# K8s
if [ "$ROLE" = "k8s" ]; then
    bash /vagrant/scripts/kubernetes.sh
fi

# ETCDs
if [ "$ROLE" = "etcd" ]; then
    bash /vagrant/scripts/etcd.sh
fi

# LoadBalancer
if [ "$ROLE" = "loadbalancer" ]; then
    bash /vagrant/scripts/loadbalancer.sh
fi


echo -e "=========================================== Final: $(whoami) ===========================================\n"
