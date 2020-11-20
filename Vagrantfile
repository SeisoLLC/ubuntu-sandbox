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

  # Setup Docker and give the vagrant user permissions
  config.vm.provision "shell", inline: <<-SHELL
    set -o errtrace
    set -o nounset
    set -o errexit
    set -o pipefail

    apt-get update
    apt-get -y upgrade
    apt-get -y install --no-install-recommends docker.io \
                                               cgroup-tools \
                                               libcap-ng-utils \
                                               bpftrace
    # gVisor
    URL=https://storage.googleapis.com/gvisor/releases/release/latest
    wget --quiet ${URL}/runsc ${URL}/runsc.sha512 \
      ${URL}/gvisor-containerd-shim ${URL}/gvisor-containerd-shim.sha512 \
      ${URL}/containerd-shim-runsc-v1 ${URL}/containerd-shim-runsc-v1.sha512
    sha512sum -c runsc.sha512 \
      -c gvisor-containerd-shim.sha512 \
      -c containerd-shim-runsc-v1.sha512
    rm -f *.sha512
    chmod a+rx runsc gvisor-containerd-shim containerd-shim-runsc-v1
    mv runsc gvisor-containerd-shim containerd-shim-runsc-v1 /usr/local/bin
    /usr/local/bin/runsc install
    systemctl enable --now docker
    systemctl restart docker
    usermod -aG docker vagrant
  SHELL

  # Used to set the Vagrant machine name
  config.vm.define NAME do |t|
  end
end

