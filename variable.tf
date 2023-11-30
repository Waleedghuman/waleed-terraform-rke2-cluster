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

variable "rancher_workers_count" {
  default = 0
}

variable "ebs_volume_size_masters" {
  description = "Size of the EBS volume in gigabytes"
  type        = number
  default     = 20
}

variable "ebs_volume_size_workers" {
  type    = number
  default = 20
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    "Owner"       = "waleed"
    "Group"       = "rke2"
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