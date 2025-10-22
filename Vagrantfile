VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Prefijo de red (cambia aquí si necesitas otra subnet)
  network_prefix = "172.30.108"

  # Definición centralizada de nodos con nombre, IP y rol
  nodes = [
    { name: "master1", ip: "#{network_prefix}.121", role: "master" },
    { name: "master2", ip: "#{network_prefix}.122", role: "master" },
    { name: "master3", ip: "#{network_prefix}.123", role: "master" },
    { name: "worker1", ip: "#{network_prefix}.131", role: "worker" },
    { name: "worker2", ip: "#{network_prefix}.132", role: "worker" }
  ]

  # Configuración base común para todas las VMs
  config.vm.box = "generic/debian12"
  
  nodes.each do |node|
    config.vm.define node[:name] do |vm|
      vm.vm.hostname = node[:name]
      vm.vm.network "public_network", ip: node[:ip]
      vm.vm.provider "virtualbox" do |vb|
        vb.name = "k8s-#{node[:name]}"
        vb.memory = 2048
        vb.cpus = 2
      end
    end
  end

end
