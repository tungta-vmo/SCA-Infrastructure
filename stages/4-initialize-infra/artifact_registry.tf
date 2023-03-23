module "artifact_registry" {
  source = "../../modules/artifact_regsitry"
  region = var.region
  project_id = var.project_id
  format = "DOCKER"
  name = var.artifact_registry_name
  service_account = ["${data.google_project.default.number}-compute@developer.gserviceaccount.com"]
  admin_service_account = [module.bastion_host.service_account_email]
  module_depend_on = [module.bastion_host]
}