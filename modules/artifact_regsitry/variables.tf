variable "region" {
  type = string
  default = "australia-southeast1"
}

variable "name" {
  type = string
  default = "dev-cp-registry-0"
}

variable "format" {
  type = string
  default = "docker"
}

variable "project_id" {
  type = string
  default = "vmo-dev-cp-0"
}

variable "service_account" {
  type = list(string)
  default = null
}

variable "admin_service_account" {
  type = list(string)
  default = []
}

variable "module_depend_on" {
  type = list(any)
  default = []
}