#!/bin/bash

ROLE=$1
NETWORK_PREFIX=$2

echo -e "\n=========================================== kubernetes.sh ===========================================\n"

# IPs de los nodos del cluster
MASTER1_IP="${NETWORK_PREFIX}.101"
MASTER2_IP="${NETWORK_PREFIX}.102"
MASTER3_IP="${NETWORK_PREFIX}.103"
ETCD1_IP="${NETWORK_PREFIX}.107"
ETCD2_IP="${NETWORK_PREFIX}.108"
ETCD3_IP="${NETWORK_PREFIX}.109"
LOADBALANCER_IP="${NETWORK_PREFIX}.110"

# Obtener hostname (master1)
NODE_NAME=$(hostname)


echo "----------------------------------------"
echo "   CONFIGURACION DEL NODO K8S"
echo "----------------------------------------"
echo "  Hostname        : $NODE_NAME"
echo "----------------------------------------"
echo "  MASTER1_IP      : $MASTER1_IP"
echo "  MASTER2_IP      : $MASTER2_IP"
echo "  MASTER3_IP      : $MASTER3_IP"
echo "  ETCD1_IP        : $ETCD1_IP"
echo "  ETCD2_IP        : $ETCD2_IP"
echo "  ETCD3_IP        : $ETCD3_IP"
echo "  LOADBALANCER_IP : $LOADBALANCER_IP"
echo "----------------------------------------"
echo ""

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
# se ignoran 127.0.0.1 (loopback) y eth0 (NAT de Vagrant), usamos eth1 (Adaptador puente)
IP=$(hostname -I | awk '{print $2}')
HOSTNAME=$(hostname)
echo "$IP $HOSTNAME" >> /etc/hosts
# grep -q "$HOSTNAME" /etc/hosts || echo "$IP $HOSTNAME" >> /etc/hosts

# Crear el directorio para los certificados etcd
mkdir -vp /etcd/kubernetes/pki/etcd/

# nano kubernetes.sh
# chmod +x kubernetes.sh
# ./kubernetes.sh


# Token para bootstrap de kubeadm
K8S_TOKEN=$(kubeadm token generate) # kubeadm token create

# Certificate key para unir otros masters
K8S_CERT_KEY=$(kubeadm certs certificate-key)

# Versión de Kubernetes a instalar
K8S_VERSION="1.34.0"


# Crear archivo kubeadm-config.yml
cat <<EOF > /root/kubeadm-config.yml
apiVersion: kubeadm.k8s.io/v1beta4
kind: InitConfiguration
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: ${K8S_TOKEN}     # abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
certificateKey: ${K8S_CERT_KEY}
localAPIEndpoint:
  advertiseAddress: ${MASTER1_IP}
  bindPort: 6443
nodeRegistration:
  criSocket: unix:///var/run/containerd/containerd.sock
  imagePullPolicy: IfNotPresent
  imagePullSerial: true
  name: ${NODE_NAME}
  taints: null
timeouts:
  controlPlaneComponentHealthCheck: 4m0s
  discovery: 5m0s
  etcdAPICall: 2m0s
  kubeletHealthCheck: 4m0s
  kubernetesAPICall: 1m0s
  tlsBootstrap: 5m0s
  upgradeManifests: 5m0s
---
apiVersion: kubeadm.k8s.io/v1beta4
kind: ClusterConfiguration
apiServer:
  certSANs:
    - "${LOADBALANCER_IP}"
    - "127.0.0.1"
caCertificateValidityPeriod: 87600h0m0s
certificateValidityPeriod: 8760h0m0s
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controlPlaneEndpoint: "${LOADBALANCER_IP}:6443"
controllerManager: {}
dns: {}
encryptionAlgorithm: RSA-2048
etcd:
  external:
    endpoints:
      - "https://${ETCD1_IP}:2379"
      - "https://${ETCD2_IP}:2379"
      - "https://${ETCD3_IP}:2379"
    caFile: "/etcd/kubernetes/pki/etcd/ca.pem"
    certFile: "/etcd/kubernetes/pki/etcd/etcd.pem"
    keyFile: "/etcd/kubernetes/pki/etcd/etcd-key.pem"
imageRepository: registry.k8s.io
kubernetesVersion: ${K8S_VERSION}   # 1.34.0
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
proxy: {}
scheduler: {}
EOF


# Eliminar si no es master1
if [ "$NODE_NAME" != "master1" ]; then
    rm -f /root/kubeadm-config.yml
fi


# kubeadm init --config kubeadm-config.yml --upload-certs --dry-run

# kubeadm config images pull --config kubeadm-config.yml
# crictl images

# kubeadm init --config /root/kubeadm-config.yml --upload-certs
# kubeadm init --config kubeadm-config.yml --upload-certs


