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

#------------------------------------------------------------
# Resource settings
#-----------------------------------------------------------
variable "region" {
  description = "GCP Region where the resources will be deployed"
  type        = string
  default     = "europe-west2"
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
# variable "environment_description" {
#   description = "Description of the environment"
#   type        = string
# }
# variable "environment_labels" {
#   description = "Labels to apply to the environment"
#   type        = map(string)
#   default = {
#     "environment" = var.environment
#     "name"        = var.name_prefix
#     "project"     = var.project_id
#   }
# }

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

