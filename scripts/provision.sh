#!/bin/bash

echo -e "\n=========================================== Inicio: $(whoami) ==========================================="

# Cambiar al usuario root
# sudo su -

# Llamar al script config.sh
bash /vagrant/scripts/config.sh

# Llamar al script docker.sh para instalar Docker
# bash /vagrant/scripts/docker.sh

echo -e "=========================================== Final: $(whoami) ===========================================\n"
