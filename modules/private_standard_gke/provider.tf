terraform {
  required_version = ">= 1.3.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.40.0" # tftest
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.40.0" # tftest
    }
  }
}

provider "google" {
  region = var.region
  project = var.project_id
}

provider "google-beta" {
  region = var.region
  project = var.project_id
}