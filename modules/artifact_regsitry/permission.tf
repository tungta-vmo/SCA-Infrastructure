resource "google_artifact_registry_repository_iam_member" "repo_iam" {
  for_each = { for key, val in var.service_account: key => val }
  provider = google-beta
  location = google_artifact_registry_repository.default.location
  repository = google_artifact_registry_repository.default.name
  role = "roles/artifactregistry.reader"
  member = "serviceAccount:${each.value}"
}

resource "google_artifact_registry_repository_iam_member" "admin_iam" {
  for_each = { for key, val in var.admin_service_account: key => val }
  provider = google-beta
  location = google_artifact_registry_repository.default.location
  repository = google_artifact_registry_repository.default.name
  role = "roles/artifactregistry.writer"
  member = "serviceAccount:${each.value}"
}