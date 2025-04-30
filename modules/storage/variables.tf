# This file defines the input variables for the storage module.
variable "environment" {
  description = "The deployment environment"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "europe-west2"
}