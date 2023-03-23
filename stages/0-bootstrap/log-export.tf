locals {
  log_sink_destinations = merge(
    { for k, v in var.log_sinks : k => module.log-export-dataset.0 if v.type == "bigquery" },
    { for k, v in var.log_sinks : k => module.log-export-gcs.0 if v.type == "storage" },
    module.log-export-pubsub,
    module.log-export-logbucket
  )
  log_types = toset([for k, v in var.log_sinks : v.type])
}

module "log-export-project" {
  source = "../../modules/project"
  name   = "audit-logs-0"
  parent = coalesce(
    var.project_parent_ids.logging, "organizations/${var.organization.id}"
  )
  prefix          = local.prefix
  billing_account = var.billing_account.id
  iam = {
    "roles/owner" = [module.automation-tf-bootstrap-sa.iam_email]
  }
  services = [
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "stackdriver.googleapis.com"
  ]
}

# one log export per type, with conditionals to skip those not needed

module "log-export-dataset" {
  source        = "../../modules/bigquery-dataset"
  count         = contains(local.log_types, "bigquery") ? 1 : 0
  project_id    = module.log-export-project.project_id
  id            = "audit_export"
  friendly_name = "Audit logs export."
  location      = var.locations.bq
}

module "log-export-gcs" {
  source        = "../../modules/gcs"
  count         = contains(local.log_types, "storage") ? 1 : 0
  project_id    = module.log-export-project.project_id
  name          = "audit-logs-0"
  prefix        = local.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
}

module "log-export-logbucket" {
  source      = "../../modules/logging-bucket"
  for_each    = toset([for k, v in var.log_sinks : k if v.type == "logging"])
  parent_type = "project"
  parent      = module.log-export-project.project_id
  id          = "audit-logs-${each.key}"
  location    = var.locations.logging
}

module "log-export-pubsub" {
  source     = "../../modules/pubsub"
  for_each   = toset([for k, v in var.log_sinks : k if v.type == "pubsub"])
  project_id = module.log-export-project.project_id
  name       = "audit-logs-${each.key}"
  regions    = var.locations.pubsub
}
