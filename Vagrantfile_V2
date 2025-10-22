Vagrant.configure("2") do |config|
  # Configuración para Master1
  config.vm.define "Master1" do |server|
    server.vm.box = "debian/bookworm64"
    server.vm.hostname = "master1"
    server.vm.network "public_network", ip: "192.168.0.101"

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.name = "Master1"
      vb.customize ["modifyvm", :id, "--name", "Master1"]
    end

    server.vm.provision "shell", path: "provision.sh"
  end

  # Configuración para Master2
  config.vm.define "Master2" do |server|
    server.vm.box = "debian/bookworm64"
    server.vm.hostname = "master2"
    server.vm.network "public_network", ip: "192.168.0.102"

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.name = "Master2"
      vb.customize ["modifyvm", :id, "--name", "Master2"]
    end

    server.vm.provision "shell", path: "provision.sh"
  end

  # Configuración para Master3
  config.vm.define "Master3" do |server|
    server.vm.box = "debian/bookworm64"
    server.vm.hostname = "master3"
    server.vm.network "public_network", ip: "192.168.0.103"

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.name = "Master3"
      vb.customize ["modifyvm", :id, "--name", "Master3"]
    end

    server.vm.provision "shell", path: "provision.sh"
  end

  # Configuración para Worker1
  config.vm.define "Worker1" do |server|
    server.vm.box = "debian/bookworm64"
    server.vm.hostname = "worker1"
    server.vm.network "public_network", ip: "192.168.0.104"

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.name = "Worker1"
      vb.customize ["modifyvm", :id, "--name", "Worker1"]
    end

    server.vm.provision "shell", path: "provision.sh"
  end

  # Configuración para Worker2
  config.vm.define "Worker2" do |server|
    server.vm.box = "debian/bookworm64"
    server.vm.hostname = "worker2"
    server.vm.network "public_network", ip: "192.168.0.105"

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.name = "Worker2"
      vb.customize ["modifyvm", :id, "--name", "Worker2"]
    end

    server.vm.provision "shell", path: "provision.sh"
  end

  # Configuración para Worker3
  config.vm.define "Worker3" do |server|
    server.vm.box = "debian/bookworm64"
    server.vm.hostname = "worker3"
    server.vm.network "public_network", ip: "192.168.0.106"

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.name = "Worker3"
      vb.customize ["modifyvm", :id, "--name", "Worker3"]
    end

    server.vm.provision "shell", path: "provision.sh"
  end

  # Configuración para LoadBalancer
  config.vm.define "LoadBalancer" do |server|
    server.vm.box = "debian/bookworm64"
    server.vm.hostname = "loadbalancer"
    server.vm.network "public_network", ip: "192.168.0.107"

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.name = "LoadBalancer"
      vb.customize ["modifyvm", :id, "--name", "LoadBalancer"]
    end

    server.vm.provision "shell", path: "provision.sh"
  end
end
