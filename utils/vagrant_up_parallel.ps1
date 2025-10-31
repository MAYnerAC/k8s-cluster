# Ejecutar vagrant up en varias máquinas, manteniendo la ventana de PowerShell abierta
Start-Process powershell -ArgumentList "-NoExit", "vagrant up Master1"
Start-Process powershell -ArgumentList "-NoExit", "vagrant up Master2"
Start-Process powershell -ArgumentList "-NoExit", "vagrant up Master3"
Start-Process powershell -ArgumentList "-NoExit", "vagrant up Worker1"
Start-Process powershell -ArgumentList "-NoExit", "vagrant up Worker2"
Start-Process powershell -ArgumentList "-NoExit", "vagrant up Worker3"
Start-Process powershell -ArgumentList "-NoExit", "vagrant up LoadBalancer"

# vagrant box list
# vagrant box add debian/bookworm64
# vagrant box list
# .\up_paralelo.ps1