variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "crypto_keys" {
  type = map(object({
    name                = string
    service_account_key = string
  }))
  description = "Map of crypto keys to create, with associated service account keys."
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the KMS key ring."
}

variable "service_accounts" {
  type = map(object({
    account_id   = string
    display_name = string
    description  = string
  }))
  description = "Service accounts for IAM bindings."
}