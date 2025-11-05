# Centralizar tres primeros octetos
network_prefix = "172.30.108"

# VMs config (IP, nombre, memoria, CPUs)
machines = [
  # Masters(3)
  { name: "Master1", hostname: "master1", ip: "#{network_prefix}.101", memory: 2048, cpus: 2, role: "k8s" },
  { name: "Master2", hostname: "master2", ip: "#{network_prefix}.102", memory: 2048, cpus: 2, role: "k8s" },
  { name: "Master3", hostname: "master3", ip: "#{network_prefix}.103", memory: 2048, cpus: 2, role: "k8s" },

  # Workers(3)
  { name: "Worker1", hostname: "worker1", ip: "#{network_prefix}.104", memory: 2048, cpus: 2, role: "k8s" },
  { name: "Worker2", hostname: "worker2", ip: "#{network_prefix}.105", memory: 2048, cpus: 2, role: "k8s" },
  { name: "Worker3", hostname: "worker3", ip: "#{network_prefix}.106", memory: 2048, cpus: 2, role: "k8s" },

  # ETCDs(3)
  { name: "ETCD1", hostname: "etcd1", ip: "#{network_prefix}.107", memory: 2048, cpus: 2, role: "etcd" },
  { name: "ETCD2", hostname: "etcd2", ip: "#{network_prefix}.108", memory: 2048, cpus: 2, role: "etcd" },
  { name: "ETCD3", hostname: "etcd3", ip: "#{network_prefix}.109", memory: 2048, cpus: 2, role: "etcd" },

  # LoadBalancer(1)
  { name: "LoadBalancer", hostname: "loadbalancer", ip: "#{network_prefix}.110", memory: 2048, cpus: 2, role: "loadbalancer" }
]

# Ansible(1) (definida fuera del arreglo)
ansible_vm = { name: "Ansible", hostname: "ansible", ip: "#{network_prefix}.111", memory: 2048, cpus: 2, role: "ansible" }

Vagrant.configure("2") do |config|
  # Configuración para las VMs (bucle)
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

      server.vm.provision "shell", path: "scripts/provision.sh", args: [machine[:role], network_prefix]#, [machine[:hostname]
    end
  end

  # VM para Ansible Controller
  config.vm.define ansible_vm[:name] do |ansible|
    ansible.vm.box = "debian/bookworm64"
    ansible.vm.hostname = ansible_vm[:hostname]
    ansible.vm.network "public_network", ip: ansible_vm[:ip]

    ansible.vm.provider "virtualbox" do |vb|
      vb.memory = ansible_vm[:memory]
      vb.cpus = ansible_vm[:cpus]
      vb.name = ansible_vm[:name]
      vb.customize ["modifyvm", :id, "--name", ansible_vm[:name]]
    end

    ansible.vm.provision "file", source: "./ansible", destination: "/tmp/ansible", run: "always"
    ansible.vm.provision "shell" do |shell|
      shell.path = "./scripts/provision.sh"
      shell.args = [ansible_vm[:role], network_prefix]
    end
  end

end
