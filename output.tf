output "ip_addresses" {
  value = {
    for key, m in module.masters : 
      key => {
        "private_ip" = m.private_ip
        "public_ip"  = m.public_ip
      }
    if length(module.masters) > 0
  }
}