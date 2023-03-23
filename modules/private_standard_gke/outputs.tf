output "gke_endpoint" {
  value = "https://${google_container_cluster.default.endpoint}"
}

output "gke_private_ip" {
  value = google_container_cluster.default.endpoint
}

output "gke_cluster_ca_cert" {
  value = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)
}

output "node_version" {
 value = google_container_cluster.default.node_version
}

output "master_version" {
  value = google_container_cluster.default.master_version
}

output "workload_identity" {
  value = google_container_cluster.default.workload_identity_config[0].workload_pool
}