#!/bin/bash
export INSTALL_RKE2_VERSION=v1.24.10+rke2r1
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
# #!/bin/bash
# #                                    Input Parameters:
# # $1: RKE2 Token
# # $2: RKE2 Server IP/Hostname
# # $3: Node Name
# # $4: TLS SAN 1
# # $5: TLS SAN 2
# # $6: TLS SAN 3
# # $7: TLS SAN 4
