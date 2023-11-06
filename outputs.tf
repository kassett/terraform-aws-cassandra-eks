
output "username" {
  value     = var.username
  sensitive = true
}

output "password" {
  value     = var.password != null ? var.password : random_password.db[0].result
  sensitive = true
}

output "uri" {
  value = try(data.kubernetes_service.db.status.0.load_balancer.0.ingress.0.hostname, null)
}

output "cloudwatch-exporter-iam-role" {
  value = try(aws_iam_role.irsa[0].arn, null)
}