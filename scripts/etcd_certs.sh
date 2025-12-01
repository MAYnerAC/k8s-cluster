#!/bin/bash

ROLE=$1
NETWORK_PREFIX=$2

echo -e "\n=========================================== etcd_certs.sh ===========================================\n"

# IPs del cluster etcd
ETCD1_IP="${NETWORK_PREFIX}.107"
ETCD2_IP="${NETWORK_PREFIX}.108"
ETCD3_IP="${NETWORK_PREFIX}.109"


# Generacion de certificados (Uno por cluster etcd)

mkdir openssl
cd openssl

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







: <<'END'
#----------------------------------------------------------------------------------------------------------------------------------------#

# Generacion de certificados (Uno por cada nodo etcd)

mkdir openssl
cd openssl

# ==========================================================
# CA (solo una vez)
# Archivos generados:
#   - ca.pem        → copiar a TODOS los nodos
#   - ca-key.pem    → NO compartir
# ==========================================================

openssl genrsa -out ca-key.pem 2048
openssl req -new -key ca-key.pem -out ca-csr.pem -subj "/CN=etcd cluster"
openssl x509 -req -in ca-csr.pem -out ca.pem -days 3650 -signkey ca-key.pem -sha256

# Key
# CSR
# SAN
# Firmar

# ==========================================================
# NODO 1 (etcd1)
# ==========================================================

openssl genrsa -out etcd1-key.pem 2048
openssl req -new -key etcd1-key.pem -out etcd1-csr.pem -subj "/CN=etcd1"
echo "subjectAltName = DNS:localhost,IP:192.168.0.107,IP:127.0.0.1" > etcd1-ext.cnf
openssl x509 -req -in etcd1-csr.pem -CA ca.pem -CAkey ca-key.pem -CAcreateserial -days 3650 -out etcd1.pem -sha256 -extfile etcd1-ext.cnf


# ==========================================================
# NODO 2 (etcd2)
# ==========================================================

openssl genrsa -out etcd2-key.pem 2048
openssl req -new -key etcd2-key.pem -out etcd2-csr.pem -subj "/CN=etcd2"
echo "subjectAltName = DNS:localhost,IP:192.168.0.108,IP:127.0.0.1" > etcd2-ext.cnf
openssl x509 -req -in etcd2-csr.pem -CA ca.pem -CAkey ca-key.pem -CAcreateserial -days 3650 -out etcd2.pem -sha256 -extfile etcd2-ext.cnf


# ==========================================================
# NODO 3 (etcd3)
# ==========================================================

openssl genrsa -out etcd3-key.pem 2048
openssl req -new -key etcd3-key.pem -out etcd3-csr.pem -subj "/CN=etcd3"
echo "subjectAltName = DNS:localhost,IP:192.168.0.109,IP:127.0.0.1" > etcd3-ext.cnf
openssl x509 -req -in etcd3-csr.pem -CA ca.pem -CAkey ca-key.pem -CAcreateserial -days 3650 -out etcd3.pem -sha256 -extfile etcd3-ext.cnf


# 9 archivos

# Nodo1:
# ca.pem
# etcd1.pem
# etcd1-key.pem

# Nodo2:
# ca.pem
# etcd2.pem
# etcd2-key.pem

# Nodo3:
# ca.pem
# etcd3.pem
# etcd3-key.pem

#----------------------------------------------------------------------------------------------------------------------------------------#
END




# Mover certificados a las VMs Etcd "/var/lib/etcd/" 

# (Opcion1)
# Se recomienda usar claves SSH
# scp -i <clave_ssh> ca.pem etcd.pem etcd-key.pem root@<ip_servidor>:/var/lib/etcd

# (Opcion2)
# Usando sshpass
# sshpass -p "Upt2025" scp ca.pem etcd.pem etcd-key.pem root@192.168.0.107:/var/lib/etcd/
# sshpass -p "Upt2025" scp ca.pem etcd.pem etcd-key.pem root@192.168.0.108:/var/lib/etcd/
# sshpass -p "Upt2025" scp ca.pem etcd.pem etcd-key.pem root@192.168.0.109:/var/lib/etcd/

sshpass -p "Upt2025" scp -o StrictHostKeyChecking=no ca.pem etcd.pem etcd-key.pem root@172.30.105.107:/var/lib/etcd/
sshpass -p "Upt2025" scp -o StrictHostKeyChecking=no ca.pem etcd.pem etcd-key.pem root@172.30.105.108:/var/lib/etcd/
sshpass -p "Upt2025" scp -o StrictHostKeyChecking=no ca.pem etcd.pem etcd-key.pem root@172.30.105.109:/var/lib/etcd/

# Mover certificados a las VMs K8s-Control-Plane "/etcd/kubernetes/pki/etcd/" 

# K8s-Control-Plane: mkdir -vp /etcd/kubernetes/pki/etcd/

sshpass -p "Upt2025" scp ca.pem etcd.pem etcd-key.pem root@192.168.0.101:/etcd/kubernetes/pki/etcd/
sshpass -p "Upt2025" scp ca.pem etcd.pem etcd-key.pem root@192.168.0.102:/etcd/kubernetes/pki/etcd/
sshpass -p "Upt2025" scp ca.pem etcd.pem etcd-key.pem root@192.168.0.103:/etcd/kubernetes/pki/etcd/


