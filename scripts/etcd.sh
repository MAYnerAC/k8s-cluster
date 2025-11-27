#!/bin/bash

ROLE=$1
NETWORK_PREFIX=$2

echo -e "\n=========================================== etcd.sh ===========================================\n"

# IPs del cluster etcd
ETCD1_IP="${NETWORK_PREFIX}.107"
ETCD2_IP="${NETWORK_PREFIX}.108"
ETCD3_IP="${NETWORK_PREFIX}.109"


# Obtener hostname (etcd1, etcd2, etcd3)
NODE_NAME=$(hostname)


# Asignar IP según hostname
if [ "$NODE_NAME" = "etcd1" ]; then
    NODE_IP="$ETCD1_IP"
elif [ "$NODE_NAME" = "etcd2" ]; then
    NODE_IP="$ETCD2_IP"
elif [ "$NODE_NAME" = "etcd3" ]; then
    NODE_IP="$ETCD3_IP"
else
    echo "ERROR: Nodo $NODE_NAME"
    exit 1
fi


# Crear el servicio etcd
cat <<EOF > /etc/systemd/system/etcd.service
[Unit]
Description=etcd

[Service]
ExecStart=/usr/local/bin/etcd \\
  --name ${NODE_NAME} \\
  --initial-advertise-peer-urls https://${NODE_IP}:2380 \\
  --listen-peer-urls https://${NODE_IP}:2380 \\
  --listen-client-urls https://${NODE_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${NODE_IP}:2379 \\
  --initial-cluster-token etcd-cluster-1 \\
  --initial-cluster etcd1=https://${ETCD1_IP}:2380,etcd2=https://${ETCD2_IP}:2380,etcd3=https://${ETCD3_IP}:2380 \\
  --log-outputs=/var/lib/etcd/etcd.log \\
  --initial-cluster-state new \\
  --peer-auto-tls \\
  --snapshot-count '10000' \\
  --wal-dir=/var/lib/etcd/wal \\
  --client-cert-auth \\
  --trusted-ca-file=/var/lib/etcd/ca.pem \\
  --cert-file=/var/lib/etcd/etcd.pem \\
  --key-file=/var/lib/etcd/etcd-key.pem \\
  --data-dir=/var/lib/etcd/data
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable etcd
