# Masters module
module "masters" {
  source                      = "./ec2"
  for_each                    = { for i in range(0, var.rancher_masters_count) : "master${i}" => i }
  scope                       = each.key
  instance_type               = var.instance_type
  subnet_id                   = module.networking.subnet_id["default"]
  tags                        = var.tags
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.networking.sg_id]
  ami                         = var.ami
  ebs_volume                  = var.ebs_volume_size_masters
}

# Workers module
module "workers" {
  source                      = "./ec2"
  for_each                    = { for i in range(0, var.rancher_workers_count) : "worker${i}" => i }
  scope                       = each.key
  instance_type               = var.instance_type
  subnet_id                   = module.networking.subnet_id["default"]
  tags                        = var.tags
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.networking.sg_id]
  ami                         = var.ami
  ebs_volume                  = var.ebs_volume_size_workers
}




locals {
  master_private_ips = [
    for i in range(0, var.rancher_masters_count) : module.masters["master${i}"].private_ip
  ]
}

locals {
  worker_private_ips = [
    for i in range(0, var.rancher_workers_count) : module.workers["worker${i}"].private_ip
  ]
}






resource "aws_route53_record" "main" {
  count   = var.rancher_masters_count != 0 ? 1 : 0
  zone_id = "Z02745981J3FQC8Y0Z4P7"
  name    = "waleed"
  type    = "A"
  ttl     = 300
  records = [module.masters["master0"].public_ip]
}

# Configure remote execution for master0
resource "null_resource" "remote_exec_master0" {
  count = var.rancher_masters_count != 0 ? 1 : 0
  connection {
    host        = module.masters["master0"].public_ip
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "scripts/master.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "echo 'Waiting for cloud-init to complete...'",
      "until sudo cloud-init status --wait > /dev/null 2>&1; do sleep 1; done",
      "echo 'Completed cloud-init!'",
      "sudo bash /tmp/install.sh '${module.masters["master0"].hostname}' '${module.masters["master0"].private_ip}' '${join("' '", local.master_private_ips)}' '${aws_route53_record.main[0].fqdn}'",
      "sleep 10",
      "exit",
    ]
  }
}


resource "null_resource" "remote_exec_masters" {
  count = var.rancher_masters_count > 1 ? var.rancher_masters_count - 1 : 0 # Exclude the first machine

  connection {
    host        = module.masters["master${count.index + 1}"].public_ip # it will Start count.index from 1 by excluding 1st machine
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "scripts/master-2&3.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "until sudo cloud-init status --wait > /dev/null 2>&1; do sleep 1; done",
      "echo 'Completed cloud-init!'",
      "sudo bash /tmp/install.sh '${data.external.get_token[0].result.token}' '${module.masters["master0"].private_ip}' '${module.masters["master${count.index + 1}"].hostname}' '${join("' '", local.master_private_ips)}' '${aws_route53_record.main[0].fqdn}'",
      "sleep 10",
      "exit",
    ]
  }
}



resource "null_resource" "remote_exec_workers" {
  count = var.rancher_workers_count

  connection {
    host        = module.workers["worker${count.index}"].public_ip
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "scripts/workers.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "until sudo cloud-init status --wait > /dev/null 2>&1; do sleep 1; done",
      "echo 'Completed cloud-init!'",
      "sudo bash /tmp/install.sh '${module.masters["master0"].private_ip}' '${data.external.get_token[0].result.token}' '${module.workers["worker${count.index}"].hostname}' ${join("' '", local.master_private_ips)} '${aws_route53_record.main[0].fqdn}'",
      # "sudo bash /tmp/install.sh '${module.masters["master0"].private_ip}' '${data.external.get_token[0].result.token}' '${module.workers["worker${count.index}"].hostname}' '${join("' '", local.master_private_ips)}' '${aws_route53_record.main[0].fqdn}'",
      # "sudo bash /tmp/install.sh '${module.masters["master0"].private_ip}' '${data.external.get_token[0].result.token}' '${module.masters["worker${count.index}"].hostname}''${join("' '", local.master_private_ips)}' '${aws_route53_record.main[0].fqdn}'",
      # "sudo bash /tmp/install.sh '${aws_route53_record.main[0].fqdn}' '${data.external.get_token[0].result.token}' '${join("' '", local.master_private_ips)}'",
      # "sudo bash /tmp/install.sh '${data.external.get_token[0].result.token}' '${module.masters["master0"].private_ip}' '${module.masters["master${count.index + 1}"].hostname}' '${join("' '", local.master_private_ips)}' '${aws_route53_record.main[0].fqdn}'",
      "sleep 10",
      "exit",
    ]
  }
}
# resource "null_resource" "remote_exec_workers" {
#   count = var.rancher_workers_count

#   connection {
#     host        = module.workers["worker${count.index}"].public_ip # it will start from 0 count.index
#     type        = "ssh"
#     user        = var.ssh_user
#     private_key = file(var.private_key_path)
#   }

#   provisioner "file" {
#     source      = "scripts/workers.sh"
#     destination = "/tmp/install.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Waiting for cloud-init to complete...'",
#       "until sudo cloud-init status --wait > /dev/null 2>&1; do sleep 1; done",
#       "echo 'Completed cloud-init!'",
#       "sudo bash /tmp/install.sh '${aws_route53_record.main[0].fqdn}'",
#       "sleep 10",
#       "exit",
#     ]
#   }
# }

# Retrieve the token using an external data source
data "external" "get_token" {
  count = var.rancher_masters_count != 0 ? 1 : 0
  program = ["bash", "-c", <<-EOF
    until token=$(ssh -o StrictHostKeyChecking=no -i ${var.private_key_path} ${var.ssh_user}@${module.masters["master0"].public_ip} 'sudo cat /var/lib/rancher/rke2/server/node-token'); do sleep 1; done
    echo "{\"token\":\"$token\"}"
    EOF
  ]
  depends_on = [null_resource.remote_exec_master0[0]]
}

# Configure remote execution for Rancher installation

# resource "null_resource" "remote_exec_rancher" {
#   count = var.rancher_masters_count != 0 ? 1 : 0
#   connection {
#     host        = module.masters["master0"].public_ip
#     type        = "ssh"
#     user        = var.ssh_user
#     private_key = file(var.private_key_path)
#   }

#   provisioner "file" {
#     source      = "scripts/rancher.sh"
#     destination = "/tmp/install.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "set -e",
#       "echo 'Waiting for cloud-init to complete...'",
#       "until sudo cloud-init status --wait > /dev/null 2>&1; do sleep 1; done",
#       "echo 'Completed cloud-init!'",
#       "sudo bash /tmp/install.sh '${aws_route53_record.main[0].fqdn}'",
#       "sleep 10",
#       "exit",
#     ]
#   }
#   depends_on = [null_resource.remote_exec_masters[0], null_resource.remote_exec_workers]
# }

# resource "null_resource" "remote_exec_rancher" {
#   count = var.rancher_masters_count != 0 ? 1 : 0
#   connection {
#     host        = module.masters["master0"].public_ip
#     type        = "ssh"
#     user        = var.ssh_user
#     private_key = file(var.private_key_path)
#   }

#   provisioner "file" {
#     source      = "scripts/rancher.sh"
#     destination = "/tmp/install.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "set -e",
#       "echo 'Waiting for cloud-init to complete...'",
#       "until sudo cloud-init status --wait > /dev/null 2>&1; do sleep 1; done",
#       "echo 'Completed cloud-init!'",
#       "sudo bash /tmp/install.sh '${aws_route53_record.main[0].fqdn}'",
#       "sleep 10",
#       "exit",
#     ]
#   }
#   depends_on = [null_resource.remote_exec_masters[0]]
# }
#=================================================================================================


