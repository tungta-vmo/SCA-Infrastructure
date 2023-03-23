resource "kubernetes_service_account_v1" "network_service_account" {
  metadata {
    name = var.networking_service_account
    namespace = kubernetes_namespace.network.metadata[0].name
    annotations = {
      "iam.gke.io/gcp-service-account": "${var.networking_service_account}@${var.project_id}.iam.gserviceaccount.com"
    }
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels
    ]
  }
}