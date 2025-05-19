variable "project_id" {
  type        = string
  description = "The GCP Project ID."
}

variable "service_accounts" {
  type = map(object({
    account_id   = string
    display_name = string
    description  = string
  }))
  description = "Service accounts to create."
}

variable "service_account_roles" {
  type        = map(list(string))
  description = "IAM roles to assign to service accounts, mapping service account keys to lists of role names."
  validation {
    condition     = alltrue([for k in keys(var.service_account_roles) : contains(keys(var.service_accounts), k)])
    error_message = "All service_account_roles keys must match service_accounts keys."
  }
}