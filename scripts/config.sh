#!/bin/bash

echo -e "\n=========================================== config.sh ===========================================\n"

# Actualizar el sistema
sudo apt update
sudo apt upgrade -y

# Instalar zstd
# sudo apt install -y zstd
# sudo update-initramfs -u

# Asegurar que los archivos de configuración de ssh se manejen adecuadamente
### sudo apt-get -o Dpkg::Options::="--force-confnew" upgrade -y
# sudo apt-get -o Dpkg::Options::="--force-confold" upgrade -y
###echo "openssh-server ssh/sshd_config file-not-unique" | sudo debconf-set-selections


# Configurar idioma del sistema
# sudo update-locale LANG=en_US.UTF-8 #(NO)

# Configurar la zona horaria
# sudo timedatectl set-timezone US/Pacific #(NO)

# Configurar el teclado
# sudo localectl set-keymap latam #(NO)

# Cambiar el hostname
# sudo hostnamectl set-hostname anahua # (En Vagrantfile)

# Configurar la sincronización de hora
sudo timedatectl status
sudo timedatectl set-ntp true

# Zona horaria a America/Lima
sudo timedatectl set-timezone America/Lima

# Establecer contraseña root
echo "root:Upt2025" | sudo chpasswd

# Crear un usuario con contraseña
sudo useradd -m -s /bin/bash anahua
echo "anahua:Upt2025" | sudo chpasswd

# Agregar el usuario al grupo sudo
sudo usermod -aG sudo anahua

# Permitir login SSH
sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Instalar SSH (Formulario de configuracion)
# sudo apt install -y openssh-server
# systemctl enable ssh
# systemctl start ssh

# Otros paquetes
# sudo apt install -y 
