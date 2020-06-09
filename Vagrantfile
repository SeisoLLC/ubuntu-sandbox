# -*- mode: ruby -*-
# vi: set ft=ruby :

NAME = "ubuntu-sandbox"

Vagrant.configure("2") do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.hostname = NAME

  # Setup the vmware_desktop provider
  config.vm.provider "vmware_desktop" do |v|
    v.vmx["memsize"] = 4096
    v.vmx["numvcpus"] = 2
  end

  # Setup Docker and give the vagrant user permissions
  config.vm.provision "shell", inline: <<-SHELL
    apt update
    apt upgrade
    apt install -y docker.io \
                   cgroup-tools
    systemctl enable --now docker
    usermod -aG docker vagrant
  SHELL

  # Used to set the Vagrant machine name
  config.vm.define NAME do |t|
  end
end

