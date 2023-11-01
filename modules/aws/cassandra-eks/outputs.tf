
output "username" {
  value     = var.user
  sensitive = true
}

output "password" {
  value     = data.external.db.result.password
  sensitive = true
}