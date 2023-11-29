variable "tags" {
  type        = map(string)
  description = "Tags for the EC2 instance"
}

variable "ami" {
  description = "Pattern to match AMI names"
  default = {
    name   = ""
    owners = [""]
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
variable "key_name" {
  type = string
}

variable "subnet_id" {
  description = "ID of the subnet in which to launch the EC2 instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the EC2 instance"
  type        = list(string)
  default     = null
}

variable "remote_exec" {
  description = "script for EC2 instance"
  default = {
    script = null
    vars   = null
    files  = null
  }
}

variable "enable_eip" {
  description = "Set to true to allocate an Elastic IP, or false to not allocate one"
  type        = bool
  default     = false
}

variable "eip_domain" {
  description = "Domain for Elastic IP (vpc or standard)"
  type        = string
  default     = "vpc"
}

variable "allow_policy_roles" {
  description = "List of IAM managed policy ARNs to attach to the EC2 instance role"
  type        = list(string)
  default     = null
}


variable "scope" {
  description = "scope for which you want to use resources"
  type        = string
}

variable "associate_public_ip_address" {
  description = "associate_public_ip_address to ec2"
  default     = false
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs. Defaults true."
  default     = true
}

variable "ebs_volume" {
  default = null
}
