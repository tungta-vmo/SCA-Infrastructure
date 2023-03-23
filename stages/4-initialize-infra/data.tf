data "google_client_config" "client" {}

data "google_compute_network" "shared_vpc" {
  name = var.shared_vpc_network_name
  project = var.shared_vpc_host_project_id
}

data "google_compute_subnetwork" "subnet_shared_vpc"  {
  name = var.subnet_shared_vpc_name
  project = var.shared_vpc_host_project_id
  region = var.region
}

data "google_project" "default" {
  project_id = var.project_id
}