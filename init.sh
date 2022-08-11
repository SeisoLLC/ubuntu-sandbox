#!/usr/bin/env bash

set -o errtrace
set -o nounset
set -o errexit
set -o pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade
apt-get -y install --no-install-recommends bpftrace \
                                           cgroup-tools \
                                           devscripts \
                                           docker.io \
                                           python3-pip \
                                           libcap-ng-utils\
                                           tor \
                                           torsocks
pip3 install pysocks

# Kubernetes and related setup
snap install kubectl --classic
curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.11.0/kind-linux-amd64
chmod +x /usr/local/bin/kind

if [[ "$(uname -m)" != "arm64" && "$(uname -m)" != "aarch64" ]]; then
  # gVisor and docker setup
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
fi

# Firewall setup
ufw default allow outgoing
ufw default deny incoming
ufw allow in on eth0 to any port 22 proto tcp
ufw logging medium
echo "y" | ufw enable
