# Output the reserved ip address.
output "reserved_ip_address" {
  value = digitalocean_reserved_ip.default.ip_address
}
