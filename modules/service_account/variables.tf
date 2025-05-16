variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "account_id" {
  description = "The account ID of the Service Account"
  type        = string
}

variable "display_name" {
  description = "The display name of the Service Account"
  type        = string
}

variable "description" {
  description = "Description of the Service Account"
  type        = string
  default     = null
}

variable "service_account_email" {
  description = "Email of the service account"
  type        = string
}