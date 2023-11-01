
variable "image-repository" {
  type        = string
  default     = "bitnami/cassandra"
  description = "Specify a custom image repository. Defaults to the official Cassandra repo."
}

variable "image-registry" {
  type        = string
  default     = "docker.io"
  description = "Specify a registry other docker.io."
}

variable "image-tag" {
  type        = string
  default     = "latest"
  description = "Specify an image tag. Defaults to latest."
}

variable "replicas" {
  type        = number
  default     = 3
  description = "Number of Cassandra nodes."
}

variable "helm-chart-version" {
  type        = string
  default     = null
  description = "Specify the version of the Helm chart for the database. Default to latest."
}

variable "additional-db-helm-configurations" {
  type        = any
  default     = null
  description = "Specify any additional configurations for the Cassandra helm chart (YAML encoded)."
}

variable "cassandra-namespace" {
  type    = string
  default = "cassandra"
}

variable "enable-prometheus-metrics" {
  type    = bool
  default = false
}

variable "prometheus-namespace" {
  type    = string
  default = "monitoring"
}

variable "prometheus-scraping-interval" {
  type        = number
  default     = null
  description = "Number of seconds between each metric collection."
}

variable "service-type" {
  type    = string
  default = "LoadBalancer"
}

variable "prometheus-annotations" {
  type        = string
  default     = null
  description = "Annotations to be attached to Prometheus sidecar."
}

variable "cql-port" {
  type    = number
  default = 9042
}

variable "metrics-port" {
  type    = number
  default = 8080
}

variable "cassandra-startup-scripts" {
  default     = null
  type        = list(string)
  description = "Scripts to be run when a pod is initialized."
}

variable "username" {
  type    = string
  default = "cassandra"
}

variable "password" {
  type    = string
  default = null
}

variable "seed-count" {
  type = number
}

variable "rack-name" {
  type    = string
  default = null
}

variable "datacenter-name" {
  type    = string
  default = null
}

variable "storage-class" {
  type    = string
  default = "gp3"
}

variable "enable-alerting" {
  type    = bool
  default = true
  validation {
    condition = var.enable-prometheus-metrics
  }
}

variable "cloudwatch-alarm-arn" {
  type    = string
  default = null
}

variable "environment" {
  type    = string
  default = "stage"
}

variable "dbs-credentials-secrets" {
  type    = string
  default = null
}

variable "annotations" {
  type = map(string)
  default = null
  description = "Annotations for the Cassandra statefulset."
}

variable "labels" {
  type = map(string)
  default = null
  description = "Labels for the Cassandra statefulset."
}

variable "service-account-name" {
  type = string
  default = "cassandra"
  description = "The name of the service account for the statefulset to use."
}

variable "create-service-account" {
  default = true
  type = bool
}

variable "service-account-annotations" {
  type = map(string)
  default = null
  description = "The annotations for the service account for the Cassandra statefulset."
}

variable "volume-storage-size" {
  type = number
  default = 8
  description = "The size (gigabytes) of the volumes."
}

variable "commit-log-volume-size" {
  type = number
  default = 2
  description = "The size (gigabytes) of the commit log volume."
}
