terraform {
  backend "gcs" {
    bucket                      = "${bucket}"
    impersonate_service_account = "${sa}"
    %{~ if backend_extra != null ~}
    ${indent(4, backend_extra)}
    %{~ endif ~}
  }
}
provider "google" {
  impersonate_service_account = "${sa}"
}
provider "google-beta" {
  impersonate_service_account = "${sa}"
}
