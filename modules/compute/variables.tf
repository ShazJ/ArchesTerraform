# modules/compute/variables.tf
variable "project_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_sa_email" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "e2-standard-2"
}
###########
variable "instance_name" {}
variable "machine_type" {}
variable "zone" {}
variable "network" {}
variable "subnetwork" {}
########
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
}

variable "subnet_self_link" {
  description = "Self-link of the subnet"
  type        = string
}

variable "service_account" {
  description = "Service account email"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the VM"
  type        = string
  default     = "e2-medium"
}