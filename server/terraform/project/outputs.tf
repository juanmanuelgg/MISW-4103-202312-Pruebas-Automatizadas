/*
# Saca un error de información sensible
# Output the database user password
output "postgres_password" {
  value = digitalocean_database_user.user_example.password
}
*/