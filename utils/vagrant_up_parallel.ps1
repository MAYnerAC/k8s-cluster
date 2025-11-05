# Ejecutar vagrant up en varias máquinas, manteniendo la ventana de PowerShell abierta

# Masters
Start-Process powershell -ArgumentList "-NoExit", "vagrant up Master1"
#Start-Process powershell -ArgumentList "-NoExit", "vagrant up Master2"
#Start-Process powershell -ArgumentList "-NoExit", "vagrant up Master3"

# Workers
Start-Process powershell -ArgumentList "-NoExit", "vagrant up Worker1"
Start-Process powershell -ArgumentList "-NoExit", "vagrant up Worker2"
Start-Process powershell -ArgumentList "-NoExit", "vagrant up Worker3"

# ETCDs
#Start-Process powershell -ArgumentList "-NoExit", "vagrant up ETCD1"
#Start-Process powershell -ArgumentList "-NoExit", "vagrant up ETCD2"
#Start-Process powershell -ArgumentList "-NoExit", "vagrant up ETCD3"

# Load Balancer
#Start-Process powershell -ArgumentList "-NoExit", "vagrant up LoadBalancer"

# Ansible Controller
#Start-Process powershell -ArgumentList "-NoExit", "vagrant up Ansible"

# vagrant box list
# vagrant box add debian/bookworm64
# vagrant box list

# .\utils\vagrant_up_parallel.ps1