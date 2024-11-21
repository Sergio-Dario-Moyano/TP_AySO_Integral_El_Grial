# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "Ubuntu_Testing" do |ubuntu|
    ubuntu.vm.box = "ubuntu/bionic64"
    ubuntu.vm.hostname = "testing"
    ubuntu.vm.network "private_network", :name => '', ip: "192.168.56.4"
    
    # Comparto la carpeta del host donde estoy parado contra la vm
    ubuntu.vm.synced_folder 'compartido_Host1/', '/home/vagrant/compartido', 
    owner: 'vagrant', group: 'vagrant' 

      # Agrega la key Privada de ssh en .vagrant/machines/default/virtualbox/private_key
      ubuntu.ssh.insert_key = true
      # Agrego un nuevo disco 
      ubuntu.vm.disk :disk, size: "5GB", name: "#{ubuntu.vm.hostname}_extra_storage"
      ubuntu.vm.disk :disk, size: "3GB", name: "#{ubuntu.vm.hostname}_extra_storage2"
      ubuntu.vm.disk :disk, size: "2GB", name: "#{ubuntu.vm.hostname}_extra_storage3"
      ubuntu.vm.disk :disk, size: "1GB", name: "#{ubuntu.vm.hostname}_extra_storage4"

      ubuntu.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.name = "ubuntu"
        vb.cpus = 1
        vb.linked_clone = true
        # Seteo controladora Grafica
        vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']      
      end    
      # Puedo Ejecutar un script que esta en un archivo
      ubuntu.vm.provision "shell", path: "script_Enable_ssh_password.sh"
      ubuntu.vm.provision "shell", path: "instala_paquetes.sh"
      ubuntu.vm.provision "shell", privileged: false, inline: <<-SHELL
      # Los comandos aca se ejecutan como vagrant
  
      mkdir -p /home/vagrant/repogit
      cd /home/vagrant/repogit
      git clone https://github.com/upszot/UTN-FRA_SO_onBording.git 
      git clone https://github.com/upszot/UTN-FRA_SO_Ansible.git
      git clone https://github.com/upszot/UTN-FRA_SO_Docker.git

    SHELL
    end
    
    
    config.vm.define "Fedora_Production" do |fedora|
      fedora.vm.box = "generic/fedora34"
      fedora.vm.hostname = "production"
      fedora.vm.network "private_network", :name => '', ip: "192.168.56.5"
      
      # Comparto la carpeta del host donde estoy parado contra la vm
      fedora.vm.synced_folder 'compartido_Host2/', '/home/vagrant/compartido'
  
    # Agrega la key Privada de ssh en .vagrant/machines/default/virtualbox/private_key
    fedora.ssh.insert_key = true
    fedora.vm.provider "virtualbox" do |vb2|
      vb2.memory = "1024"
      vb2.name = "fedora"
      vb2.cpus = 1
      vb2.linked_clone = true
      # Seteo controladora Grafica
      vb2.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
    end
    
    
    # Puedo Ejecutar un script que esta en un archivo
    fedora.vm.provision "shell", path: "script_Enable_ssh_password.sh"
    
    # Provisión para instalar
    fedora.vm.provision "shell", inline: <<-SHELL
      dnf install -y /home/vagrant/compartido/tree-1.8.0-10.el9.x86_64.rpm

      subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
      dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    SHELL
  end
end
