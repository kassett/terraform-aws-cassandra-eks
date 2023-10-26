
variable "image_repository" {
  type = string
  default = "cassandra/cassandra"
  description = "Specify a custom image repository. Defaults to the official Cassandra repo."
}

variable "image_registry" {
  type = string
  default = "docker.io"
  description = "Specify a registry other docker.io."
}

variable "image_tag" {
  type = string
  default = "latest"
  description = "Specify an image tag. Defaults to latest."
}

variable "replicas" {
  type = number
  default = 3
  description = "Number of Cassandra nodes."
}

variable "helm_chart_version" {
  type = string
  default = null
  description = "Specify the version of the Helm chart for the database. Default to latest."
}

variable "additional_db_helm_configurations" {
  type = any
  default = null
  description = "Specify any additional configurations for the Cassandra helm chart (YAML encoded)."
}

variable "cassandra_namespace" {
  type = string
  default = "cassandra"
}

variable "enable_prometheus_metrics" {
  type = bool
  default = false
}

variable "prometheus_namespace" {
  type = string
  default = "monitoring"
}

variable "prometheus_scraping_interval" {
  type = number
  default = null
  description = "Number of seconds between each metric collection."
}

variable "service_type" {
  type = string
  default = "LoadBalancer"
}

variable "prometheus_annotations" {
  type = string
  default = null
  description = "Annotations to be attached to "
}

variable "cql_port" {
  type = number
  default = 9042
}

variable "metrics_port" {
  type = number
  default = 8080
}

variable "cassandra_startup_scripts" {
  default = null
  type = list(string)
  description = "Scripts to be run when a pod is initialized."
}

variable "user" {
  type = string
  default = "cassandra"
}

variable "password" {
  type = string
  default = null
}

variable "seed_count" {
  type = number
}

variable "rack-name" {
  type = string
  default = null
}

variable "datacenter-name" {
  type = string
  default = null
}

variable "storage_class" {
  type = string
  default = "gp2"
}