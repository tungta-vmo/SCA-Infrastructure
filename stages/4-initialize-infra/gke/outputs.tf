output "service_account_information" {
  value = {
    "${var.networking_service_account}" = kubernetes_service_account_v1.network_service_account.metadata[0].namespace
  }
}