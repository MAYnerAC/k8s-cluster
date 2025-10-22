#!/bin/bash

echo -e "\n=========================================== docker.sh ===========================================\n"

# 1. Eliminar paquetes en conflicto (si es que existen)
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove -y $pkg; done

# 2. Actualizar sistema e instalar dependencias
apt-get install -y ca-certificates curl

# 3. Agregar la clave GPG oficial de Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# 4. Agregar el repositorio oficial de Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Instalar Docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 6. Verificar que Docker funcione correctamente
docker ps

# 7. Permitir usar Docker sin root
apt-get install -y passwd
usermod -aG docker anahua
newgrp docker
