# This file contains the variable definitions for the Terraform configuration.
# It includes variables for project settings, Kubernetes cluster configuration,
# and other parameters needed for the deployment.
#-----------------------------------------------------------
#-----------------------------------------------------------
# # Project settings
#-----------------------------------------------------------
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}
# variable "project_name" {
#   description = "Name of the project"
#   type        = string
#   default = "value"
# }
# variable "project_description" {
#   description = "Description of the project"
#   type        = string
# }
# variable "project_labels" {
#   description = "Labels to apply to the project"
#   type        = map(string)
# }

#------------------------------------------------------------
# Resource settings
#-----------------------------------------------------------
variable "region" {
  description = "GCP Region where the resources will be deployed"
  type        = string
  default     = "europe-west2"
}
variable "zone" {
  description = "Zone where the resources will be deployed"
  type        = string
  default     = ""
}

#-----------------------------------------------------------
# # Environment settings
#-----------------------------------------------------------
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "stg", "uat", "prod"], var.environment)
    error_message = "Environment must be 'dev', 'stg', 'uat' or 'prod'."
  }
}
variable "environment_description" {
  description = "Description of the environment"
  type        = string
}
variable "environment_labels" {
  description = "Labels to apply to the environment"
  type        = map(string)
    default     = {
        "environment" = var.environment
        "name" = var.name_prefix
        "project" = var.project_id 
    }
}
variable "environment_type" {
  description = "Type of environment (e.g., dev, staging, prod)"
  type        = string
}
#-----------------------------------------------------------
# # Resource prefix and suffix
#-----------------------------------------------------------
variable "name_prefix" {
  description = "Suffix to append to resource names"
  type        = string
  default = "${var.project_id}"
}
variable "name_suffix" {
  description = "Suffix to append to resource names"
  type        = string
  default = "${var.environment}"
}

# #-----------------------------------------------------------
# # Kubernetes cluster variables
# #-----------------------------------------------------------
# variable "cluster_name" {
#   description = "Name of the Kubernetes cluster"
#   type        = string
# }
# variable "cluster_description" {
#   description = "Description of the Kubernetes cluster"
#   type        = string
# }
# variable "cluster_labels" {
#   description = "Labels to apply to the Kubernetes cluster"
#   type        = map(string)
# }
# variable "istio_ip_names" {
#   description = "IP names for Istio (GCP only)"
#   type        = list(string)
# }
# variable "bucket_infix" {
#   description = "Infix for bucket names"
#   type        = string
# }
# variable "security_group" {
#   description = "Security group for the Kubernetes cluster (GCP only)"
#   type        = string
# }
# variable "node_pools" {
#   description = "Node pools for the Kubernetes cluster"
#   type        = list(object({
#     name       = string
#     node_count = number
#     machine_type = string
#     disk_size   = number
#   }))
# }

# # variable "region" {
# #   description = "Region for the Kubernetes cluster"
# #   type        = string
# # }
# # variable "zone" {
# #   description = "Zone for the Kubernetes cluster (GCP only)"
# #   type        = string
# # }
# variable "flux_sa_email" {
#   description = "Email address of the Flux service account"
#   type        = string
# }
# variable "flux_sa" {
#   description = "Flux service account details"
#   type        = object({
#     email       = string
#     display_name = string
#   })
# }

# variable "master_authorized_networks" {
#   description = "List of authorized networks for the Kubernetes master (GCP only)"
#   type        = list(object({
#     cidr_block   = string
#     display_name = string
#   }))
#   default = []
# }

