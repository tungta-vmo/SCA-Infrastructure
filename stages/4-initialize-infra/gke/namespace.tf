resource "kubernetes_namespace" "network" {
  metadata {
    name = var.network_namespace
  }
}