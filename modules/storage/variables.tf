variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
}

variable "bucket_name" {
  description = "Name of the tenant GCS bucket"
  type        = string
}

variable "logs_bucket_name" {
  description = "Name of the logs GCS bucket"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}