resource "google_storage_bucket_object" "providers" {
  for_each = local.providers
  bucket   = module.automation-tf-output-gcs.name
  name    = "providers/${each.key}-providers.tf"
  content = each.value
}

resource "google_storage_bucket_object" "tfvars" {
  bucket  = module.automation-tf-output-gcs.name
  name    = "tfvars/0-bootstrap.auto.tfvars.json"
  content = jsonencode(local.tfvars)
}

resource "google_storage_bucket_object" "tfvars_globals" {
  bucket  = module.automation-tf-output-gcs.name
  name    = "tfvars/globals.auto.tfvars.json"
  content = jsonencode(local.tfvars_globals)
}