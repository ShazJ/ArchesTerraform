variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "name" {
  description = "The name of the Compute Route"
  type        = string
}

variable "network" {
  description = "The network for the Route"
  type        = string
}

variable "dest_range" {
  description = "The destination CIDR range for the Route"
  type        = string
}

variable "priority" {
  description = "The priority of the Route"
  type        = number
}

variable "description" {
  description = "Description of the Route"
  type        = string
}