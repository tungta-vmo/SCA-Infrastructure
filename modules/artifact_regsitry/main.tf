resource "google_artifact_registry_repository" "default" {
  provider = google-beta
  location = var.region
  repository_id = var.name
  description = "${var.format} Repository"
  format = upper(var.format)
  project = var.project_id
}

resource "null_resource" "module_depend_on" {
  triggers = {
    value = length(var.module_depend_on)
  }
}