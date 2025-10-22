#!/bin/bash

echo -e "\n=========================================== Inicio: $(whoami) ==========================================="

# Cambiar al usuario root
# sudo su -

# Llamar al script config.sh
bash /vagrant/config.sh

# Llamar al script docker.sh para instalar Docker
# bash /vagrant/docker.sh

echo -e "=========================================== Final: $(whoami) ===========================================\n"
