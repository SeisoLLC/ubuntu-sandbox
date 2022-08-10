# -*- mode: ruby -*-
# vi: set ft=ruby :

NAME = "ubuntu-sandbox"

Vagrant.configure("2") do |config|
  config.vm.box = ENV['OS']
  config.vm.hostname = NAME
  config.vm.define NAME

  # Setup the virtualbox provider
  config.vm.provider "virtualbox" do |vb|
    vb.name = NAME

    # Customize the VM resources
    vb.memory = 8192
    vb.cpus = 2

    vb.customize ['modifyvm', :id, '--clipboard-mode', 'bidirectional']
  end

  # Setup the parallels provider
  config.vm.provider "parallels" do |prl|
    prl.name = NAME

    # Customize the VM resources
    prl.memory = 8192
    prl.cpus = 2

    # prl.update_guest_tools = true
  end

  config.vm.provision "shell", path: "init.sh"
end
