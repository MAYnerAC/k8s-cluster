# Centralizar tres primeros octetos
network_prefix = "172.30.108"

# VMs config (IP, nombre, memoria, CPUs)
machines = [
  # Workers(3)
  { name: "Master1", hostname: "master1", ip: "#{network_prefix}.101", memory: 2048, cpus: 2 },
  { name: "Master2", hostname: "master2", ip: "#{network_prefix}.102", memory: 2048, cpus: 2 },
  { name: "Master3", hostname: "master3", ip: "#{network_prefix}.103", memory: 2048, cpus: 2 },

  # Masters(3)
  { name: "Worker1", hostname: "worker1", ip: "#{network_prefix}.104", memory: 2048, cpus: 2 },
  { name: "Worker2", hostname: "worker2", ip: "#{network_prefix}.105", memory: 2048, cpus: 2 },
  { name: "Worker3", hostname: "worker3", ip: "#{network_prefix}.106", memory: 2048, cpus: 2 },

  # ETCDs(3)
#  { name: "ETCD1", hostname: "etcd1", ip: "#{network_prefix}.107", memory: 2048, cpus: 2 },
#  { name: "ETCD2", hostname: "etcd2", ip: "#{network_prefix}.108", memory: 2048, cpus: 2 },
#  { name: "ETCD3", hostname: "etcd3", ip: "#{network_prefix}.109", memory: 2048, cpus: 2 },

  # LoadBalancer(1)
  { name: "LoadBalancer", hostname: "loadbalancer", ip: "#{network_prefix}.110", memory: 2048, cpus: 2 }
]

Vagrant.configure("2") do |config|
  # Configuración para las VMs
  machines.each do |machine|
    config.vm.define machine[:name] do |server|
      server.vm.box = "debian/bookworm64"
      server.vm.hostname = machine[:hostname]
      server.vm.network "public_network", ip: machine[:ip]#, bridge: "auto"

      server.vm.provider "virtualbox" do |vb|
        vb.memory = machine[:memory]
        vb.cpus = machine[:cpus]
        vb.name = machine[:name]
        vb.customize ["modifyvm", :id, "--name", machine[:name]]
      end

      server.vm.provision "shell", path: "scripts/provision.sh"
    end
  end
end
