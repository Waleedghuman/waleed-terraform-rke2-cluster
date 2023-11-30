locals {
  resource_name = "${var.tags["Owner"]}_${var.tags["Group"]}_${var.tags["Environment"]}_${var.scope}"
}

# Data Source for the latest Amazon Machine Image (AMI)
data "aws_ami" "main" {
  most_recent = true
  owners      = var.ami.owners

  filter {
    name   = "name"
    values = [var.ami.name]
  }
}

# Define the Amazon Elastic Compute Cloud (EC2) instance
resource "aws_instance" "main" {
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  ami                         = data.aws_ami.main.id
  vpc_security_group_ids      = var.vpc_security_group_ids
  source_dest_check           = var.source_dest_check
  associate_public_ip_address = var.associate_public_ip_address
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.ebs_volume
  }
  tags = {
    Name = "${local.resource_name}"
  }
}

# Define IAM Roles and Instance Profile
resource "aws_iam_role" "main" {
  count               = var.allow_policy_roles != null ? 1 : 0
  name                = "${local.resource_name}_ec2_role"
  managed_policy_arns = var.allow_policy_roles

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "main" {
  count = var.allow_policy_roles != null ? 1 : 0
  name  = "${local.resource_name}_ec2_role_profile"
  role  = aws_iam_role.main[0].name
}

# Allocate an Amazon Elastic IP (EIP) address
resource "aws_eip" "main" {
  count  = var.enable_eip ? 1 : 0
  domain = var.eip_domain
  tags = {
    Name = "${local.resource_name}_ec2_eip"
  }
}

# Associate the Elastic IP with the EC2 instance
resource "aws_eip_association" "main" {
  count         = var.enable_eip ? 1 : 0
  instance_id   = aws_instance.main.id
  allocation_id = aws_eip.main[0].id
}