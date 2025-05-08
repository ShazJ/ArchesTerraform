variable "environment" {
  description = "The deployment environment"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}