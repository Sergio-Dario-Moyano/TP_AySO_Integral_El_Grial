Vagrant.configure("2") do |config|
  # Configuración de la máquina Ubuntu (Testing)
  config.vm.define "ubuntu_testing" do |ubuntu|
    ubuntu.vm.box = "ubuntu/bionic64"  # Usando Ubuntu 18.04 LTS
    ubuntu.vm.hostname = "ubuntu-testing"
    
    # Configuración de disco
    ubuntu.vm.disk :disk, size: "5GB", name: "disk1"
    ubuntu.vm.disk :disk, size: "3GB", name: "disk2"
    ubuntu.vm.disk :disk, size: "2GB", name: "disk3"
    ubuntu.vm.disk :disk, size: "1GB", name: "disk4"
      # Configuración de red para Ubuntu
    ubuntu.vm.network "private_network", ip: "192.168.56.10"
    ubuntu.vm.provider "virtualbox" do |vb|
     vb.name = "ubuntu-testing"
    end
    # Aprovisionamiento
    ubuntu.vm.provision "shell", inline: <<-SHELL
      # Actualizar el sistema
      apt-get update
      apt-get upgrade -y

      # Instalar programas necesarios
      
    SHELL
  end

  # Configuración de la máquina Fedora (Producción)
  config.vm.define "fedora_production" do |fedora|
    fedora.vm.box = "generic/fedora28"  # Usando Fedora 28
    fedora.vm.hostname = "fedora-production"
    
    # Configuración de disco
    fedora.vm.disk :disk, size: "5GB", name: "disk1"
    fedora.vm.disk :disk, size: "3GB", name: "disk2"
    fedora.vm.disk :disk, size: "2GB", name: "disk3"
    fedora.vm.disk :disk, size: "1GB", name: "disk4"
    fedora.vm.network "private_network", ip: "192.168.56.11"
    fedora.vm.provider "virtualbox" do |vb|
     vb.name = "fedora-production"
    end
    # Aprovisionamiento
    fedora.vm.provision "shell", inline: <<-SHELL
      # Actualizar el sistema
      dnf update -y

     
    SHELL
  end

  

  # Configuración SSH para acceso sin clave
  config.vm.provision "shell", inline: <<-SHELL
    # Generar claves SSH si no existen
    if [ ! -f ~/.ssh/id_rsa ]; then
      ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
    fi

    # Copiar la clave pública a la VM
    cat ~/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
  SHELL

  # Configuración de sudo sin clave
  config.vm.provision "shell", inline: <<-SHELL
    echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
  SHELL
end
