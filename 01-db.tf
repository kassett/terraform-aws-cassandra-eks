
resource "random_password" "db" {
  count   = var.password == null ? 1 : 0
  length  = 16
  special = false
}

locals {
  basic-db-configurations = {
    "image.registry"                   = var.image-registry
    "image.repository"                 = var.image-repository
    "image.tag"                        = var.image-tag
    "replicaCount"                     = var.replicas
    "cluster.seedCount"                = var.seed-count
    "persistence.storageClass"         = var.storage-class
    "service.type"                     = var.service-type
    "service.ports.cql"                = var.cql-port
    "serviceAccount.name"              = var.service-account-name
    "serviceAccount.create"            = var.create-service-account
    "persistence.size"                 = var.volume-storage-size
    "persistence.commitLogsize"        = var.commit-log-volume-size
    "dbUser.user"                      = var.username
    "dbUser.password"                  = var.password != null ? var.password : random_password.db[0].result
    "metrics.enabled"                  = var.enable-prometheus-metrics
    "metrics.serviceMonitor.namespace" = var.prometheus-namespace
    "metrics.serviceMonitor.enabled"   = var.enable-prometheus-metrics
    "service.loadBalancerSourceRanges" = var.allowed-nlb-cidr-blocks
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

  values = concat(
    [],
    var.additional-db-helm-configurations != null ? var.additional-db-helm-configurations : []
  )

  dynamic "set" {
    for_each = local.basic-db-configurations
    content {
      name  = set.key
      value = type(set.value) == "list" ? "{${join(",", set.value)}}" : tostring(set.value)
    }
  }
}

data "kubernetes_service" "db" {
  metadata {
    namespace = helm_release.db.namespace
    name      = "cassandra"
  }
  depends_on = [helm_release.db]
}

resource "aws_secretsmanager_secret" "db" {
  count       = var.dbs-credentials-secret-name != null ? 1 : 0
  name_prefix = var.dbs-credentials-secret-name
}

resource "aws_secretsmanager_secret_version" "db" {
  count     = var.dbs-credentials-secret-name != null ? 1 : 0
  secret_id = aws_secretsmanager_secret.db[0].id
  secret_string = jsonencode({
    "username" = var.username
    "password" = var.password != null ? var.password : random_password.db[0].result
    uri        = try(data.kubernetes_service.db.status.0.load_balancer.0.ingress.0.hostname, "")
  })
}
