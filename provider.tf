terraform {
  required_providers {
    google = { # update to latest stable 5.0 i think? sji
      source  = "hashicorp/google"
      version = ">= 4.45.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone #?
}

# ?should i version pi tf? probs sji