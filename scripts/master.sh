#!/bin/bash
export INSTALL_RKE2_VERSION=v1.24.10+rke2r1
mkdir -p /etc/rancher/rke2/
cat <<EOF >/etc/rancher/rke2/config.yaml
node-name: ${1}
tls-san:
  - ${2}
  - ${3}
  - ${4}
  - ${5}
EOF
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service
sudo snap install kubectl --classic
sudo snap install helm --classic
mkdir -p /home/ubuntu/.kube
sudo cp /etc/rancher/rke2/rke2.yaml /home/ubuntu/.kube/config
sudo chmod 644 /home/ubuntu/.kube/config
export KUBECONFIG=/home/ubuntu/.kube/config
