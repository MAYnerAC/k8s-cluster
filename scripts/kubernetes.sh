#!/bin/bash

echo -e "\n=========================================== kubernetes.sh ===========================================\n"

# Instalacion base de Kubernetes para todos los nodos (Masters y Workers)
# Ejecutamos como root

apt update && apt upgrade -y

apt install curl apt-transport-https git wget software-properties-common lsb-release ca-certificates socat -y

swapoff -a

sed -i '/swap/s/^\(.*\)$/#\1/g' /etc/fstab

modprobe overlay

modprobe br_netfilter

cat << EOF | tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update && apt-get install containerd.io -y

containerd config default | tee /etc/containerd/config.toml

sed -e's/SystemdCgroup = false/SystemdCgroup = true/g' -i /etc/containerd/config.toml

systemctl restart containerd

mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update

apt-get install -y kubeadm kubelet kubectl

apt-mark hold kubelet kubeadm kubectl

systemctl enable --now kubelet

# Seleccionar la segunda IP, que corresponde a eth1 (red principal)
# se ignoran 127.0.0.1 (loopback) y eth0 (NAT de Vagrant)
IP=$(hostname -I | awk '{print $2}')
HOSTNAME=$(hostname)
# echo "$IP $HOSTNAME" >> /etc/hosts
grep -q "$HOSTNAME" /etc/hosts || echo "$IP $HOSTNAME" >> /etc/hosts

# nano kubernetes.sh
# chmod +x kubernetes.sh
# ./kubernetes.sh