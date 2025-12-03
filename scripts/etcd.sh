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

# Instalar dependencias
apt install -y curl sshpass

# Descargar e instalar etcd

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


# : <<'END'

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


# END

# Generacion de certificados (Uno por cluster etcd)
if [ "$NODE_NAME" = "etcd1" ]; then

    # Crear y entrar al directorio de certificados
    mkdir -p /root/openssl
    cd /root/openssl

    # CA
    openssl genrsa -out ca-key.pem 2048
    openssl req -new -key ca-key.pem -out ca-csr.pem -subj "/CN=etcd cluster"
    openssl x509 -req -in ca-csr.pem -out ca.pem -days 3650 -signkey ca-key.pem -sha256

    # Certificado del servidor etcd
    openssl genrsa -out etcd-key.pem 2048
    openssl req -new -key etcd-key.pem -out etcd-csr.pem -subj "/CN=etcd"

    # SAN para el cluster
    # echo subjectAltName = DNS:localhost,IP:192.168.0.107,IP:192.168.0.108,IP:192.168.0.109,IP:127.0.0.1 > extfile.cnf
    # echo "subjectAltName = DNS:localhost,DNS:etcd1,DNS:etcd2,DNS:etcd3,IP:${ETCD1_IP},IP:${ETCD2_IP},IP:${ETCD3_IP},IP:127.0.0.1" > extfile.cnf
    echo "subjectAltName = DNS:localhost,IP:${ETCD1_IP},IP:${ETCD2_IP},IP:${ETCD3_IP},IP:127.0.0.1" > extfile.cnf

    # Firmar certificado
    openssl x509 -req -in etcd-csr.pem -CA ca.pem -CAkey ca-key.pem -CAcreateserial -days 3650 -out etcd.pem -sha256 -extfile extfile.cnf


    # cd /root/openssl
    
    sshpass -p "Upt2025" scp -o StrictHostKeyChecking=no ca.pem etcd.pem etcd-key.pem root@${ETCD1_IP}:/var/lib/etcd/
    sshpass -p "Upt2025" scp -o StrictHostKeyChecking=no ca.pem etcd.pem etcd-key.pem root@${ETCD2_IP}:/var/lib/etcd/
    sshpass -p "Upt2025" scp -o StrictHostKeyChecking=no ca.pem etcd.pem etcd-key.pem root@${ETCD3_IP}:/var/lib/etcd/
    
    # sshpass -p "Upt2025" scp -o StrictHostKeyChecking=no ca.pem etcd.pem etcd-key.pem root@192.168.0.101:/etcd/kubernetes/pki/etcd/
    # sshpass -p "Upt2025" scp -o StrictHostKeyChecking=no ca.pem etcd.pem etcd-key.pem root@192.168.0.102:/etcd/kubernetes/pki/etcd/
    # sshpass -p "Upt2025" scp -o StrictHostKeyChecking=no ca.pem etcd.pem etcd-key.pem root@192.168.0.103:/etcd/kubernetes/pki/etcd/

    # cd /var/lib/etcd/
    # cd /etcd/kubernetes/pki/etcd/

fi


# Agregar variables de entorno para etcdctl
cat <<EOF >> /root/.bashrc
export ETCDCTL_CACERT="/var/lib/etcd/ca.pem"
export ETCDCTL_CERT="/var/lib/etcd/etcd.pem"
export ETCDCTL_KEY="/var/lib/etcd/etcd-key.pem"
EOF

source /root/.bashrc


# Iniciar servicio etcd
# sudo systemctl start etcd
