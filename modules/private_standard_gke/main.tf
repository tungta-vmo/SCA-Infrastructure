resource "google_container_cluster" "default" {
  provider                 = google-beta
  name                     = var.cluster_name
  location                 = var.region
  project                  = var.project_id
  network                  = var.sharevpc_selflink
  subnetwork               = var.subnetwork_selflink
  remove_default_node_pool = true
  initial_node_count       = var.init_node_count
  enable_shielded_nodes    = true

  default_max_pods_per_node = var.default_max_pods_per_node

  logging_config {
    enable_components = var.logging_config_components
  }

  monitoring_config {
    enable_components = var.monitoring_config_components
  }

  network_policy {
    enabled = var.enable_network_policy
  }

  enable_intranode_visibility = var.enable_intranode_visibility

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool  = "${var.project_id}.svc.id.goog"
  }

  dynamic "cluster_autoscaling" {
    for_each = var.enable_cluster_autoscaling == true ? [var.enable_cluster_autoscaling] : []
    content {
      enabled = var.enable_cluster_autoscaling
      autoscaling_profile = "OPTIMIZE_UTILIZATION"
      resource_limits {
        resource_type = "cpu"
        minimum = 2
        maximum = 20
      }
      resource_limits {
        resource_type = "memory"
        minimum = 3
        maximum = 40
      }
    }
  }

  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  addons_config {
    gcp_filestore_csi_driver_config {
      enabled = true
    }
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_ip_range_name
    services_secondary_range_name = var.service_ip_range_name
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.master_authorized_cidr_block
      display_name = var.master_authorized_display_name
    }
  }
#  authenticator_groups_config {
#    security_group = "gke-security-groups@${var.organization_domain}"
#  }
}

resource "google_container_node_pool" "default_node_pool" {
  provider           = google-beta
  name               = "${var.cluster_name}-node-pool"
  location           = var.region
  initial_node_count = var.init_node_count
  cluster            = google_container_cluster.default.name
  project            = var.project_id

  autoscaling {
    min_node_count = var.node_pool_autoscaling_min_node_count
    max_node_count = var.node_pool_autoscaling_max_node_count
  }
  management {
    auto_repair  = var.node_pool_auto_repair
    auto_upgrade = var.node_pool_auto_upgrade
  }
  upgrade_settings {
    max_surge       = var.node_pool_max_surge
    max_unavailable = var.node_pool_max_unavailable
  }
  node_config {
    disk_size_gb = "${var.node_pool_disk_size_gb}"
    disk_type    = "pd-standard"
    machine_type = var.node_pool_machine_type
    image_type   = "COS_CONTAINERD"
    oauth_scopes = var.node_pool_oauth_scopes
    gcfs_config {
      enabled = var.enable_image_streaming
    }
    shielded_instance_config {
      enable_secure_boot = true
    }
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    metadata = {
      disable-legacy-endpoints = true
    }
  }
}
