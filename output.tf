output "ip_addresses" {
  value = merge(
    { for key, m in module.masters : key => {
      "private_ip" = m.private_ip,
      "public_ip"  = m.public_ip
      }
    },
    { for key, m in module.workers : key => {
      "private_ip" = m.private_ip,
      "public_ip"  = m.public_ip
      }
    }
  )
}




