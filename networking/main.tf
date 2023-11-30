# Define local variable to generate resource names based on tags
locals {
  resource_name = "${var.tags["Owner"]}_${var.tags["Group"]}_${var.tags["Environment"]}"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${local.resource_name}_vpc"
  }
}

# Create Subnets
resource "aws_subnet" "main" {
  for_each          = var.subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = format("%sb", var.region)
  tags = {
    Name = "${local.resource_name}_${each.key}_subnet"
  }
}

# Define a Security Group
resource "aws_security_group" "main" {
  count       = var.security_group_rules != null ? 1 : 0
  name        = "${local.resource_name}_sg"
  description = "Default security group"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.security_group_rules.ingress

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.security_group_rules.egress

    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${local.resource_name}_sg"
  }
}

# Create an Internet Gateway and reference vpc
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.resource_name}_igw"
  }
}

# Update the routing table to route all traffic through the Internet Gateway
resource "aws_route" "main" {
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
