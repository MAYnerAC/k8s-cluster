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


# 
echo "----------------------------------------"
echo "   CONFIGURACION DEL NODO ETCD"
echo "----------------------------------------"
echo "  Hostname        : $NODE_NAME"
echo "  IP              : $NODE_IP"
echo "----------------------------------------"
echo "  ETCD1_IP        : $ETCD1_IP"
echo "  ETCD2_IP        : $ETCD2_IP"
echo "  ETCD3_IP        : $ETCD3_IP"
echo "----------------------------------------"
echo ""


# Descargar e intalar etcd

ETCD_VER=v3.5.10

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

# Instalar los binarios de etcd en "/usr/local/bin"
mv -v /tmp/etcd-download-test/etcd /usr/local/bin
mv -v /tmp/etcd-download-test/etcdctl /usr/local/bin
mv -v /tmp/etcd-download-test/etcdutl /usr/local/bin

rm -rf /tmp/etcd-download-test

etcd --version
etcdctl version
etcdutl version

# Crear el directorio para los certificados etcd
mkdir -p /var/lib/etcd


: <<'END'

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



# Iniciar servicio etcd
sudo systemctl start etcd

END


