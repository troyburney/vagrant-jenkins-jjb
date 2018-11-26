# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "forwarded_port", guest: 80, host: 18080
  config.vm.synced_folder ".", "/mnt/host_machine"
  config.vm.provider :virtualbox do |vb|
      vb.name = "jenkins-jjb"
      vb.memory = "1024"
  end
  config.vm.provision "shell" do |s|
    s.path = "provision.sh"
  end
end
