
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
  description = "Number of Cassandra nodes."
}

variable "helm-chart-version" {
  type        = string
  default     = null
  description = "Specify the version of the Helm chart for the database. When not specified, the latest version will be used."
}

variable "additional-db-helm-configurations" {
  type        = any
  default     = null
  description = "Specify any additional configurations for the Cassandra helm chart (YAML encoded)."
}

variable "cassandra-namespace" {
  type        = string
  default     = "cassandra"
  description = "The namespace of the Cassandra statefulset."
}

variable "enable-prometheus-metrics" {
  type        = bool
  default     = false
  description = "When specified as true, a sidecar will be spun up for shipping Cassandra logs to Prometheus."
}

variable "prometheus-namespace" {
  type        = string
  default     = "monitoring"
  description = "The namespace of the Prometheus sidecar."
}

variable "prometheus-scraping-interval" {
  type        = number
  default     = null
  description = "Number of seconds between each metric collection."
}

variable "service-type" {
  type        = string
  default     = "LoadBalancer"
  description = "The type of service exposing the Cassandra statefulset. Other options include ClusterIP and NodePort."
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
  type        = string
  default     = null
  description = "If the password is left as null, it will be automatically generated."

  validation {
    condition     = var.password == null || can(regex("^[0-9A-Za-z]+$", var.password))
    error_message = "Cassandra doesn't work well with passwords with special characters."
  }
}

variable "seed-count" {
  type        = number
  description = "The number of seed nodes for persistence."
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
}

variable "cluster-name" {
  type = string
}

variable "create-cloudwatch-exporter" {
  default     = false
  type        = bool
  description = "Only one deployment need exist per cluster. If it already exists, this can be false."
}

variable "cloudwatch-exporter-namespace" {
  type        = string
  default     = "cloudwatch"
  description = "If this resource is created, it will be created in the cloudwatch namespace."
}

variable "environment" {
  type    = string
  default = "stage"
}

variable "dbs-credentials-secret-name" {
  type        = string
  default     = null
  description = "If a secret name is specified, then an AWS Secret will be uploaded with the DNS hostnames, username, and password."
}

variable "annotations" {
  type        = map(string)
  default     = null
  description = "Annotations for the Cassandra statefulset."
}

variable "labels" {
  type        = map(string)
  default     = null
  description = "Labels for the Cassandra statefulset."
}

variable "service-account-name" {
  type        = string
  default     = "cassandra"
  description = "The name of the service account for the statefulset to use."
}

variable "allowed-nlb-cidr-blocks" {
  type = list(string)
  default = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  description = "The CIDR blocks allowed by the load balancer."
}

variable "create-service-account" {
  default = true
  type    = bool
}

variable "service-account-annotations" {
  type        = map(string)
  default     = null
  description = "The annotations for the service account for the Cassandra statefulset."
}

variable "volume-storage-size" {
  type        = number
  default     = 8
  description = "The size (gigabytes) of the volumes."
}

variable "commit-log-volume-size" {
  type        = number
  default     = 2
  description = "The size (gigabytes) of the commit log volume."
}
