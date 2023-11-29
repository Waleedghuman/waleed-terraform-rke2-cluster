module "networking" {
  source               = "./networking"
  tags                 = var.tags
  region               = var.region
  vpc_cidr_block       = "10.0.0.0/16"
  security_group_rules = local.security_group_rules
  subnets              = { default = "10.0.0.0/24" }
}

resource "aws_key_pair" "main" {
  key_name   = "${var.tags.Owner}_ssh_key"
  public_key = file(var.public_key_path)
}
