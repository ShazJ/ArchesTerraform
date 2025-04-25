terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.45.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.45.0"
    }
  }
}

#-----------------------------------------------------------
# IAM
#-----------------------------------------------------------
#----------------------------------------------------------
# create service accounts for data and flux
#-----------------------------------------------------------
module "data_service_account" {
  source      = "./modules/service_account"
  account_id  = "xxx-data${var.bucket_infix}"
  display_name = "XXX Data Service Account"
}

module "flux_service_account" {
  source      = "./modules/service_account"
  account_id  = "xxx-flux${var.bucket_infix}"
  display_name = "XXX Flux Service Account"
}

#-----------------------------------------------------------
# Storage
#-----------------------------------------------------------
#-----------------------------------------------------------
# create gcs buckets for data, logs and state  #sji state - should this bucket be here??
#-----------------------------------------------------------
# resource "google_storage_bucket" "data_gsb" {
#   name          = "xxx-data-store${var.bucket_infix}"
#   location      = upper(var.region)
#   force_destroy = false
#   uniform_bucket_level_access = true
# }

# resource "google_storage_bucket" "logging_gsb" {
#   name          = "xxx-log-store${var.bucket_infix}"
#   location      = upper(var.region)
#   force_destroy = false
#   uniform_bucket_level_access = true
# }

# resource "google_storage_bucket_iam_binding" "xxx_bib" {
#   bucket = google_storage_bucket.data_gsb.name
#   role   = "roles/storage.admin"
#   members = ["serviceAccount:${var.xxx_sa_email}"]
# }

# variable "project_id" {}
# variable "master_authorized_networks" {}
# variable "security_group" {}
# variable "node_pools" {}
# variable "name_suffix" {}
# variable "bucket_infix" {}
# variable "cluster_name" {}
# variable "cluster_description" {}
# variable "region" {}
# variable "zone" {}
# variable "cluster_labels" {}
# variable "istio_ip_names" {}

# data "google_project" "project" {
#   project_id = var.project_id
# }
