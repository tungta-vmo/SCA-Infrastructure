module "automation-project" {
  source          = "../../modules/project"
  billing_account = var.billing_account.id
  name            = "iac-core-0"
  parent = coalesce(
    var.project_parent_ids.automation, "organizations/${var.organization.id}"
  )
  prefix = local.prefix
  group_iam = {
    (local.groups.gcp-devops) = [
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountTokenCreator",
    ]
    (local.groups.gcp-organization-admins) = [
      "roles/iam.serviceAccountTokenCreator",
      "roles/iam.workloadIdentityPoolAdmin"
    ]
  }
  iam = {
    "roles/owner" = [
      module.automation-tf-bootstrap-sa.iam_email
    ]
    "roles/cloudbuild.builds.editor" = [
      module.automation-tf-resman-sa.iam_email
    ]
    "roles/iam.serviceAccountAdmin" = [
      module.automation-tf-resman-sa.iam_email
    ]
    "roles/iam.workloadIdentityPoolAdmin" = [
      module.automation-tf-resman-sa.iam_email
    ]
    "roles/source.admin" = [
      module.automation-tf-resman-sa.iam_email
    ]
    "roles/storage.admin" = [
      module.automation-tf-resman-sa.iam_email
    ]
  }
  services = [
    "accesscontextmanager.googleapis.com",
    "bigquery.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigquerystorage.googleapis.com",
    "billingbudgets.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "essentialcontacts.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "orgpolicy.googleapis.com",
    "pubsub.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "sourcerepo.googleapis.com",
    "stackdriver.googleapis.com",
    "storage-component.googleapis.com",
    "storage.googleapis.com",
    "sts.googleapis.com"
  ]
}

module "automation-tf-output-gcs" {
  source        = "../../modules/gcs"
  project_id    = module.automation-project.project_id
  name          = "iac-core-outputs-0"
  prefix        = local.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  depends_on    = [module.organization]
}

module "automation-tf-bootstrap-gcs" {
  source        = "../../modules/gcs"
  project_id    = module.automation-project.project_id
  name          = "iac-core-bootstrap-0"
  prefix        = local.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  depends_on    = [module.organization]
}

module "automation-tf-bootstrap-sa" {
  source       = "../../modules/iam-service-account"
  project_id   = module.automation-project.project_id
  name         = "bootstrap-0"
  display_name = "Terraform organization bootstrap service account."
  prefix       = local.prefix
  iam = {}
  iam_storage_roles = {
    (module.automation-tf-output-gcs.name) = ["roles/storage.admin"]
  }
}

module "automation-tf-resman-gcs" {
  source        = "../../modules/gcs"
  project_id    = module.automation-project.project_id
  name          = "iac-core-resman-0"
  prefix        = local.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = [module.automation-tf-resman-sa.iam_email]
  }
  depends_on = [module.organization]
}

module "automation-tf-resman-sa" {
  source       = "../../modules/iam-service-account"
  project_id   = module.automation-project.project_id
  name         = "resman-0"
  display_name = "Terraform stage 1 resman service account."
  prefix       = local.prefix
  iam_additive = {}
  iam_storage_roles = {
    (module.automation-tf-output-gcs.name) = ["roles/storage.admin"]
  }
}
