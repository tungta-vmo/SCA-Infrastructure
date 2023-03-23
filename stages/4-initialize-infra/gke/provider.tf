terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.16.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.8.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
  }
}

provider "helm" {
  kubernetes {
    host = var.host
    token = var.token
    cluster_ca_certificate = var.cluster_ca_certificate
    proxy_url = var.proxy_url
  }
}

provider "kubernetes" {
  host = var.host
  token = var.token
  cluster_ca_certificate = var.cluster_ca_certificate
  proxy_url = var.proxy_url
}