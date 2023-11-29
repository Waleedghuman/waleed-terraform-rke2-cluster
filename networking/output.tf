output "subnet_id" {
  description = "ID of the selected subnet"
  value = {
    for subnet_key, subnet in var.subnets : subnet_key => aws_subnet.main[subnet_key].id
  }
}

output "sg_id" {
  value = aws_security_group.main[0].id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "rtb_id" {
  value = aws_vpc.main.main_route_table_id
}
