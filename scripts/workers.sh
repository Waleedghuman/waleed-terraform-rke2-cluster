#!/bin/bash
# Input Parameters:
# $1: RKE2 Token
# $2: RKE2 Server IP/Hostname
# $3: Node Name
# $4: TLS SAN 1
# $5: TLS SAN 2
# $6: TLS SAN 3
# $7: TLS SAN 4
# ${data.external.get_token[0].result.token}
# ${module.masters["master0"].private_ip}
# ${module.masters["master${count.index + 1}"].hostname}
# ${join("' '", local.master_private_ips)}
# ${aws_route53_record.main[0].fqdn}



# ${aws_route53_record.main[0].fqdn}
# ${data.external.get_token[0].result.token}
# ${join("' '", local.master_private_ips)}

export INSTALL_RKE2_VERSION=v1.24.10+rke2r1
# export INSTALL_RKE2_TYPE=agent

mkdir -p /etc/rancher/rke2/


cat <<EOF >/etc/rancher/rke2/config.yaml
token: ${2}
server: https://${1}:9345
node-name: ${3}
cni: calico
disable: rke2-ingress-nginx
cloud-provider-name: aws
EOF

curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -
systemctl enable rke2-agent.service
systemctl start rke2-agent.service
# curl -sfL https://get.rke2.io | sh -
# systemctl enable rke2-server.service
# systemctl start rke2-server.service