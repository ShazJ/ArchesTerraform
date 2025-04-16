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