terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  # If you’re using a service-account key file, set credentials_file in tfvars.
  credentials = "${path.module}/${var.credentials_file}" != "" ? file(var.credentials_file) : null
}

locals {
  prefix = var.name
}