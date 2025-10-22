# Centralizar tres primeros octetos
network_prefix = "172.30.105"

# VMs config (IP, nombre, memoria, CPUs)
machines = [
  { name: "Master1", ip: "#{network_prefix}.101", memory: 2048, cpus: 2 },
  { name: "Master2", ip: "#{network_prefix}.102", memory: 2048, cpus: 2 },
  { name: "Master3", ip: "#{network_prefix}.103", memory: 2048, cpus: 2 },
  { name: "Worker1", ip: "#{network_prefix}.104", memory: 2048, cpus: 2 },
  { name: "Worker2", ip: "#{network_prefix}.105", memory: 2048, cpus: 2 },
  { name: "Worker3", ip: "#{network_prefix}.106", memory: 2048, cpus: 2 },
  { name: "LoadBalancer", ip: "#{network_prefix}.107", memory: 2048, cpus: 2 },
]

# { name: "worker1", namo: "Worker1", ip: "#{network_prefix}.104", memory: 2048, cpus: 2 }


Vagrant.configure("2") do |config|
  # Configuración para las VMs
  machines.each do |machine|
    config.vm.define machine[:name] do |server|
      server.vm.box = "debian/bookworm64"
      server.vm.hostname = machine[:name]
      server.vm.network "public_network", ip: machine[:ip]

      server.vm.provider "virtualbox" do |vb|
        vb.memory = machine[:memory]
        vb.cpus = machine[:cpus]
        vb.name = machine[:name]
        vb.customize ["modifyvm", :id, "--name", machine[:name]]
      end

      server.vm.provision "shell", path: "provision.sh"
    end
  end
end
