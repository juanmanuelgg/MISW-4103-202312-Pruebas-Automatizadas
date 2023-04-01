# Output the reserved ip address.
output "reserved_ip_address" {
  value = digitalocean_reserved_ip.default.ip_address
}

# Output the FQDN for the www A record.
output "www_fqdn" {
  value = digitalocean_record.www.fqdn # => www.example.com
}