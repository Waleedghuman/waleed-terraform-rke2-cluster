# Define VPC CIDR block
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = null
}

# Define AWS region
variable "region" {
  description = "AWS region for the VPC and resources"
  type        = string
  default     = null
}

# Define tags
variable "tags" {
  description = "A map of tags for the VPC and associated resources"
  type        = map(string)
  default     = {}
}

# Define subnets
variable "subnets" {
  description = "A map of subnet CIDR blocks for different subnets"
  type        = map(string)
  default     = {}
}

# Define security group rules
variable "security_group_rules" {
  description = "Security group rules for ingress and egress"
  type        = object({
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
  })
  default     = null
}
