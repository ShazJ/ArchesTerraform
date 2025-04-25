variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "subnet_cidrs" {
  description = "List of subnet CIDR ranges"
  type        = list(string)
  default = "10.0.0.0/24"
}
