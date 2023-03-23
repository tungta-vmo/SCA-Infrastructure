locals {
  _tpl_providers = "${path.module}/templates/providers.tf.tpl"
  custom_roles = {
    for k, v in var.custom_role_names :
    k => try(module.organization.custom_role_id[v], null)
  }
  providers = {
    "0-bootstrap" = templatefile(local._tpl_providers, {
      backend_extra = null
      bucket        = module.automation-tf-bootstrap-gcs.name
      name          = "bootstrap"
      sa            = module.automation-tf-bootstrap-sa.email
    })
    "1-resman" = templatefile(local._tpl_providers, {
      backend_extra = null
      bucket        = module.automation-tf-resman-gcs.name
      name          = "resman"
      sa            = module.automation-tf-resman-sa.email
    })
    "0-bootstrap-tenant" = templatefile(local._tpl_providers, {
      backend_extra = join("\n", [
        "# remove the newline between quotes and set the tenant name as prefix",
        "prefix = \"",
        "\""
      ])
      bucket = module.automation-tf-resman-gcs.name
      name   = "bootstrap-tenant"
      sa     = module.automation-tf-resman-sa.email
    })
  }
  tfvars = {
    automation = {
      outputs_bucket               = module.automation-tf-output-gcs.name
      project_id                   = module.automation-project.project_id
      project_number               = module.automation-project.number
    }
    custom_roles = local.custom_roles
  }
  tfvars_globals = {
    billing_account = var.billing_account
    fast_features   = var.fast_features
    groups          = var.groups
    locations       = var.locations
    organization    = var.organization
    prefix          = var.prefix
  }
}

output "automation" {
  description = "Automation resources."
  value       = local.tfvars.automation
}

output "billing_dataset" {
  description = "BigQuery dataset prepared for billing export."
  value       = try(module.billing-export-dataset.0.id, null)
}

output "custom_roles" {
  description = "Organization-level custom roles."
  value       = local.custom_roles
}

output "outputs_bucket" {
  description = "GCS bucket where generated output files are stored."
  value       = module.automation-tf-output-gcs.name
}

output "project_ids" {
  description = "Projects created by this stage."
  value = {
    automation     = module.automation-project.project_id
    billing-export = try(module.billing-export-project.0.project_id, null)
    log-export     = module.log-export-project.project_id
  }
}

output "providers" {
  # tfdoc:output:consumers stage-01
  description = "Terraform provider files for this stage and dependent stages."
  sensitive   = true
  value       = local.providers
}

output "service_accounts" {
  description = "Automation service accounts created by this stage."
  value = {
    bootstrap = module.automation-tf-bootstrap-sa.email
    resman    = module.automation-tf-resman-sa.email
  }
}

output "tfvars" {
  description = "Terraform variable files for the following stages."
  sensitive   = true
  value       = local.tfvars
}
