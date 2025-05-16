variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "name" {
  description = "The name of the KMS Key Ring"
  type        = string
}

variable "location" {
  description = "The location for the KMS Key Ring"
  type        = string
}