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
  default = {}
}

variable "labels" {
  type    = map(string)
  default = {}
}