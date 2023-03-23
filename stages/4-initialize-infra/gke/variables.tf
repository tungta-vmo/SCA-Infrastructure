variable "project_id" {
  type = string
}

variable "host" {
  type = string
}

variable "token" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}

variable "proxy_url" {
  type = string
  default = "http://localhost:9999"
}

variable "networking_service_account" {
  type    = string
  default = null
}

variable "network_namespace" {
  type    = string
  default = "vmo-dp-networking"
}

variable "workload_name" {
  type = string
  description = "nginx-app"
}