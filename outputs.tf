
output "username" {
  value     = var.username
  sensitive = true
}

output "password" {
  value     = var.password != null ? var.password : random_password.db[0].result
  sensitive = true
}