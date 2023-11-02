
resource "random_password" "db" {
  count       = var.password == null ? 1 : 0
  length      = 16
  min_special = 2
}

locals {
  basic-db-configurations = {
    "image.registry"            = var.image-registry
    "image.repository"          = var.image-repository
    "image.tag"                 = var.image-tag
    "persistence.storageClass"  = var.storage-class
    "service.type"              = var.service-type
    "service.ports.cql"         = var.cql-port
    "serviceAccount.name"       = var.service-account-name
    "serviceAccount.create"     = var.create-service-account
    "persistence.size"          = var.volume-storage-size
    "persistence.commitLogsize" = var.commit-log-volume-size
    "dbUser.user"               = var.username
    "dbUser.password"           = var.password != null ? var.password : random_password.db[0].result
  }
}

resource "helm_release" "db" {
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "cassandra"
  namespace        = var.cassandra-namespace
  name             = "cassandra"
  version          = var.helm-chart-version
  create_namespace = true
  recreate_pods    = true

  dynamic "set" {
    for_each = local.basic-db-configurations
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "aws_secretsmanager_secret" "db" {
  count       = var.dbs-credentials-secrets != null ? 1 : 0
  name_prefix = var.dbs-credentials-secrets
}

resource "aws_secretsmanager_secret_version" "db" {
  count     = var.dbs-credentials-secrets != null ? 1 : 0
  secret_id = aws_secretsmanager_secret.db[0].id
  secret_string = jsonencode({
    "username" = var.username
    "password" = var.password != null ? var.password : random_password.db[0].result
  })
}

