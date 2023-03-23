output "id" {
  value = google_artifact_registry_repository.default.id
}

output "name" {
  value = google_artifact_registry_repository.default.name
}

output "address" {
  value = "${var.region}-docker.pkg.dev"
}