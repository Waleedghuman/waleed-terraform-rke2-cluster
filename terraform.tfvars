#dns_name       = "puff.awssolutionsprovider.com"
# aws_access_key = var.AWS_ACCESS_KEY
# aws_secret_key = var.AWS_SECRET_KEY
region                  = "us-east-2"
rancher_masters_count   = "3"
rancher_workers_count   = "3"
ebs_volume_size_masters = 20
ebs_volume_size_workers = 20
instance_type   = "t3.medium"
# tags = {
#   "Owner"       = "waleed"
#   "Group"       = "rke2"
#   "Environment" = "test"
# }
# machine_ports  = [22, 80, 443, 6443]
# image_id       = "ami-069acc051e43a100a"
# allow_tls      = "allow_tls-rnchr-2"
# key_pair       = "terraform_key-rnchr-2"
