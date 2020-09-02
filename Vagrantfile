# -*- mode: ruby -*-
# vi: set ft=ruby :

NAME = "ubuntu-sandbox"

Vagrant.configure("2") do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.hostname = NAME

  # Setup the virtualbox provider
  config.vm.provider "virtualbox" do |vb|
    vb.name = NAME

    # Customize the VM resources
    vb.memory = 4096
    vb.cpus = 2

    vb.customize ['modifyvm', :id, '--clipboard-mode', 'bidirectional']
  end

  # bash vs zsh illustrative script
  config.vm.provision "file", source: "./bash_vs_zsh.sh", destination: "${HOME}/bash_vs_zsh.sh"

  # Setup Docker and give the vagrant user permissions
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get -y upgrade
    apt-get -y install --no-install-recommends docker.io \
                                               cgroup-tools \
                                               libcap-ng-utils \
                                               zsh
    systemctl enable --now docker
    usermod -aG docker vagrant
    cp /home/vagrant/bash_vs_zsh.sh /etc/profile.d/
  SHELL

  # Used to set the Vagrant machine name
  config.vm.define NAME do |t|
  end
end

