variable "region" {
  description = "AWS region"
  type        = string
}

variable "aws_access_key" {
  description = "The AWS access key."
  type        = string
}

variable "aws_secret_key" {
  description = "The AWS secret key."
  type        = string
}

variable "rancher_masters_count" {
  default = 0
}

# variable "cluster_machine_count" {
#   default = 1
# }

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    "Owner"       = "waleed"
    "Group"       = "puffersoft"
    "Environment" = "test"
  }
}

variable "instance_type" {
  default = "t3.medium"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "private_key_path" {
  default = "./id_rsa"
}

variable "public_key_path" {
  default = "./id_rsa.pub"
}

variable "ami" {
  default = {
    name   = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230919"
    owners = ["099720109477"]
  }
}