
locals {
  basic_db_configurations = {
    "image.registry" = var.image_registry
    "image.repository" = var.image_repository
    "image.tag" = var.image_tag
    "persistence.storageClass" = var.storage_class
  }
}

resource "helm_release" "db" {
  repository = "https://charts.bitnami.com/bitnami"
  chart = "cassandra"
  namespace = var.cassandra_namespace
  name = "cassandra"
  version = var.helm_chart_version
  create_namespace = true
  recreate_pods = true

  dynamic "set" {
    for_each = local.basic_db_configurations
    content {
      name = set.key
      value = set.value
    }
  }
}

