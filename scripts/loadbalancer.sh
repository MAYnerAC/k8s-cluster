#!/bin/bash

ROLE=$1
NETWORK_PREFIX=$2

echo -e "\n=========================================== loadbalancer.sh ===========================================\n"

sudo apt update
sudo apt install haproxy -y

sudo systemctl start haproxy
sudo systemctl enable haproxy

# nano /etc/haproxy/haproxy.cfg
# nano haproxy.cfg

cat <<EOF > haproxy.cfg
frontend kubernetes-frontend
    bind ${NETWORK_PREFIX}.110:6443
    mode tcp
    option tcplog
    timeout client 10s
    default_backend kubernetes-backend

backend kubernetes-backend
    timeout connect 10s
    timeout server 10s
    mode tcp
    option tcp-check
    balance roundrobin
    server k8s-master1 ${NETWORK_PREFIX}.101:6443 check fall 3 rise 2
    server k8s-master2 ${NETWORK_PREFIX}.102:6443 check fall 3 rise 2
    server k8s-master3 ${NETWORK_PREFIX}.103:6443 check fall 3 rise 2

frontend nodeport-frontend
    bind *:30000-35000
    mode tcp
    option tcplog
    timeout client 10s
    default_backend nodeport-backend

backend nodeport-backend
    timeout connect 10s
    timeout server 10s
    mode tcp
    balance roundrobin
    server nodeport-0 ${NETWORK_PREFIX}.101
    server nodeport-1 ${NETWORK_PREFIX}.102
    server nodeport-2 ${NETWORK_PREFIX}.103
EOF

sudo mv haproxy.cfg /etc/haproxy/haproxy.cfg

sudo systemctl restart haproxy

haproxy -f /etc/haproxy/haproxy.cfg -c
