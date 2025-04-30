variable "environment" {
  description = "The deployment environment"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the VM"
  type        = string
}

variable "service_account_email" {
  description = "The email of the service account for the VM"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}