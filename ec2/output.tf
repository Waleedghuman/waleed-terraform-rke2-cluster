output "private_ip" {
  value = aws_instance.main.private_ip
}

output "public_ip" {
  value = aws_instance.main.public_ip
}

output "network_interface_id" {
  value = aws_instance.main.primary_network_interface_id
}

output "hostname" {
  value = aws_instance.main.private_dns
}

output "ami_id" {
  value = data.aws_ami.main.image_id
}
