output "public_ip" {
  description = "web server pulbic IP address to access"
  value = module.pip.public_ip.0.ip_address
}

