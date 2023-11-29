#!/bin/bash

export INSTALL_RKE2_VERSION=v1.24.10+rke2r1
#export INSTALL_RKE2_TYPE= agent

mkdir -p /etc/rancher/rke2/


cat <<EOF >/etc/rancher/rke2/config.yaml
token: ${1}
server: https://${2}:9345
node-name: ${3}
# cni: calico
tls-san:
  - ${4}
  - ${5}
  - ${6}
  - ${7}
EOF

curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service