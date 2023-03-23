module "gke" {
  source = "../../modules/private_standard_gke"
  region = var.region
  project_id = var.project_id
  cluster_name = var.gke_config.cluster_name
  organization_domain = var.gke_config.organization_domain
  sharevpc_selflink = data.google_compute_network.shared_vpc.self_link
  subnetwork_selflink = data.google_compute_subnetwork.subnet_shared_vpc.self_link
  init_node_count = var.gke_config.init_node_count
  pod_ip_range_name = data.google_compute_subnetwork.subnet_shared_vpc.secondary_ip_range[0].range_name
  service_ip_range_name = data.google_compute_subnetwork.subnet_shared_vpc.secondary_ip_range[1].range_name
  master_ipv4_cidr_block = var.gke_config.master_ipv4_cidr_block
  master_authorized_cidr_block = var.gke_config.master_authorized_cidr_block
  master_authorized_display_name = var.gke_config.master_authorized_display_name
  default_max_pods_per_node = var.gke_config.default_max_pods_per_node
  logging_config_components = var.gke_config.logging_config_components
  monitoring_config_components = var.gke_config.monitoring_config_components
  enable_intranode_visibility = var.gke_config.enable_intranode_visibility
  enable_network_policy = var.gke_config.enable_network_policy
  enable_vertical_pod_autoscaling = var.gke_config.enable_vertical_pod_autoscaling
  node_pool_autoscaling_min_node_count = var.gke_config.node_pool_autoscaling_min_node_count
  node_pool_autoscaling_max_node_count = var.gke_config.node_pool_autoscaling_max_node_count
  node_pool_max_surge = var.gke_config.node_pool_max_surge
  node_pool_max_unavailable = var.gke_config.node_pool_max_unavailable
  node_pool_auto_repair = var.gke_config.node_pool_auto_repair
  node_pool_auto_upgrade = var.gke_config.node_pool_auto_upgrade
  node_pool_machine_type = var.gke_config.node_pool_machine_type
  node_pool_disk_size_gb = var.gke_config.node_pool_disk_size_gb
  node_pool_oauth_scopes = var.gke_config.node_pool_oauth_scopes
  enable_image_streaming = var.gke_config.enable_image_streaming
  enable_cluster_autoscaling = var.gke_config.enable_cluster_autoscaling
}

module "initialize_gke" {
  source = "./gke"

  host = module.gke.gke_endpoint
  cluster_ca_certificate = file("./gke-ca-cert.pem")
  token = data.google_client_config.client.access_token
  proxy_url = "http://localhost:9999"

  project_id = var.project_id

  network_namespace = var.network_namespace

  networking_service_account = var.networking_service_account

  workload_name = var.workload_name
}