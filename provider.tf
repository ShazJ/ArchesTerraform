terraform {
  required_providers {
    google = { # update to latest stable? sji
      source  = "hashicorp/google"
      version = ">= 4.45.0"
    }
    google-beta = { #do i need this? sji
      source  = "hashicorp/google-beta"
      version = ">= 4.45.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}