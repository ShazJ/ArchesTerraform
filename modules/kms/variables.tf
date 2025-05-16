# ./modules/kms/variables.tf
variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "location" {
  description = "The location for KMS resources."
  type        = string
}

variable "region" {
  description = "The region for KMS resources."
  type        = string
}

variable "name" {
  description = "The name of the KMS key ring."
  type        = string
}

variable "infix_name" {
  description = "An infix to include in resource names."
  type        = string
}

variable "keyring_name" {
  description = "The name of the KMS key ring resource."
  type        = string
}

variable "service_account_email" {
  description = "The email of the service account to be used for KMS."
  type        = string
}

variable "crypto_keys" {
  description = "Map of crypto keys to create."
  type = map(object({
    name = string
  }))
}
# variable "iam_bindings" { 
#   description = "List of IAM bindings for KMS crypto keys"
#   type = list(object({
#     crypto_key_id = string
#     role          = string
#     members       = list(string)
#   }))
#   default = []
# }