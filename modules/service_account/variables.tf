variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
}
#sji there are a few...s
variable "sa_name" {
  description = "Name of the service account"
  type        = string
}