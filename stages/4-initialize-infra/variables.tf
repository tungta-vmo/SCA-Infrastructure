variable "project_id" {
  type        = string
  description = "Project ID of vmo-dev-cp-0"
  default     = "vmo-dev-cp-0"
}

variable "devops_group_name" {
  type        = string
  description = "DevOps Group Name of Organization"
  default     = "vmo-devops"
}

variable "organization_domain" {
  type        = string
  description = "Organization Domain on GCP"
  default     = "vmo.com"
}

variable "region" {
  type        = string
  description = "The Region will create resources"
  default     = "australia-southeast1"
}

variable "zone" {
  type    = string
  default = "australia-southeast1-a"
}

variable "shared_vpc_host_project_id" {
  type        = string
  description = "Host project of shared VPC"
  default     = "dev-net-spoke-0"
}

variable "shared_vpc_network_name" {
  type        = string
  description = "Name of Shared VPC"
  default     = "dev-spoke-0"
}

variable "subnet_shared_vpc_name" {
  type        = string
  description = "Subnet of Shared VPC Network."
  default     = "dev-dp-ase1"
}

variable "gke_config" {
  type = object({
    cluster_name = string
    organization_domain = string
    init_node_count = number
    master_ipv4_cidr_block = string
    master_authorized_cidr_block = string
    master_authorized_display_name = string
    default_max_pods_per_node = number
    logging_config_components = list(string)
    monitoring_config_components = list(string)
    enable_intranode_visibility = bool
    enable_network_policy = bool
    enable_vertical_pod_autoscaling = bool
    node_pool_autoscaling_min_node_count = number
    node_pool_autoscaling_max_node_count = number
    node_pool_max_surge = number
    node_pool_max_unavailable = number
    node_pool_auto_repair = bool
    node_pool_auto_upgrade = bool
    node_pool_machine_type = string
    node_pool_disk_size_gb = number
    node_pool_oauth_scopes = list(string)
    enable_image_streaming = bool
    enable_cluster_autoscaling = bool
  })

  default = {
    cluster_name = "dev-cp-clusters-0"
    organization_domain = "example.com"
    init_node_count = 1
    master_ipv4_cidr_block = "10.10.11.0/28"
    master_authorized_cidr_block = "10.128.32.0/24"
    master_authorized_display_name = "share_vpc_cidr"
    default_max_pods_per_node = 110
    logging_config_components = ["SYSTEM_COMPONENTS","WORKLOADS"]
    monitoring_config_components = ["SYSTEM_COMPONENTS"]
    enable_intranode_visibility = false
    enable_network_policy = true
    enable_vertical_pod_autoscaling = true
    node_pool_autoscaling_min_node_count = 1
    node_pool_autoscaling_max_node_count = 10
    node_pool_max_surge = 1
    node_pool_max_unavailable = 0
    node_pool_auto_repair = true
    node_pool_auto_upgrade = true
    node_pool_machine_type = "e2-medium"
    node_pool_disk_size_gb = 20
    node_pool_oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/cloud_debugger",
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    enable_image_streaming = true
    enable_cluster_autoscaling = false
  }
}

variable "artifact_registry_name" {
  type    = string
  default = "dev-cp-registry-0"
}

variable "bastion_host_members" {
  description = "List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email}"
  type        = list(string)
  default     = []
}

variable "bastion_host_name" {
  type    = string
  default = "dev-cp-bastion-0"
}

variable "bastion_host_name_prefix" {
  type    = string
  default = "example"
}

variable "bastion_host_image" {
  type    = string
  default = "ubuntu-minimal-2004-focal-v20221214"
}

variable "bastion_host_image_family" {
  type    = string
  default = "ubuntu-minimal-2004-lts"
}

variable "bastion_host_image_project" {
  type    = string
  default = "ubuntu-os-cloud"
}

variable "bastion_host_machine_type" {
  type    = string
  default = "g1-small"
}

variable "bastion_host_disk_size_gb" {
  type    = number
  default = 20
}

variable "bastion_host_disk_type" {
  type    = string
  default = "pd-standard"
}

variable "bastion_host_ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "bastion_host_ssh_public_key" {
  type    = string
  default = null
}

variable "bastion_host_service_account_name" {
  type    = string
  default = "dev-cp-0-bastion"
}

variable "bastion_host_firewall_rule_name" {
  type = string
  description = "The name of firewall rule will be added to host project of share-VPC to allow connection from bastion host"
  default = "allow-ssh-from-iap-to-bastion"
}

variable "workload_name" {
  type = string
  description = "nginx-app"
}

variable "networking_service_account" {
  type    = string
  default = null
}

variable "network_namespace" {
  type    = string
  default = "vmo-dp-networking"
}