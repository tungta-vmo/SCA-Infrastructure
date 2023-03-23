resource "kubernetes_secret_v1" "network_service_account_token" {
  metadata {
    namespace = kubernetes_namespace.network.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.network_service_account.metadata[0].name
    }
    name = var.networking_service_account
  }
  type = "kubernetes.io/service-account-token"
}