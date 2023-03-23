variable "region" {
  type = string
  default = "australia-southeast1"
}

variable "project_id" {
  type = string
  default = null
}

variable "cluster_name" {
  type = string
  default = null
}

variable "sharevpc_selflink" {
  type = string
  default = null
}

variable "subnetwork_selflink" {
  type = string
  default = null
}

variable "init_node_count" {
  type = number
  default = 1
}

variable "pod_ip_range_name" {
  type = string
  default = null
}

variable "service_ip_range_name" {
  type = string
  default = null
}

variable "master_ipv4_cidr_block" {
  default = "10.10.11.0/28"
}

variable "master_authorized_cidr_block" {
  default = "0.0.0.0/0"
}

variable "master_authorized_display_name" {
  default = "all"
}

variable "organization_domain" {
  type = string
  default = null
}

variable "default_max_pods_per_node" {
  default = 110
}

variable "logging_config_components" {
  default = ["SYSTEM_COMPONENTS","WORKLOADS"]
}

variable "monitoring_config_components" {
  default = ["SYSTEM_COMPONENTS"]
}

variable "enable_intranode_visibility" {
  default = false
}

variable "enable_network_policy" {
  default = true
}

variable "enable_vertical_pod_autoscaling" {
  default = true
}

variable "node_pool_autoscaling_min_node_count" {
  type = number
  default = 1
}

variable "node_pool_autoscaling_max_node_count" {
  type = number
  default = 10
}

variable "node_pool_max_surge" {
  type = number
  default = 1
}

variable "node_pool_max_unavailable" {
  type = number
  default = 0
}

variable "node_pool_auto_repair" {
  type = bool
  default = true
}

variable "node_pool_auto_upgrade" {
  type = bool
  default = true
}

variable "node_pool_machine_type" {
  type = string
  default = "e2-medium"
}

variable "node_pool_disk_size_gb" {
  type = number
  default = 20
}

variable "node_pool_oauth_scopes" {
  type = list(string)
  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/cloud_debugger",
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

variable "enable_image_streaming" {
  default = true
}

variable "enable_cluster_autoscaling" {
  default = false
}