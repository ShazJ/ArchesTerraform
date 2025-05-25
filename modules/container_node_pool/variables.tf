variable "project" {
  type        = string
  description = "The GCP project ID."
}

variable "cluster" {
  type        = string
  description = "The name of the GKE cluster."
}

variable "location" {
  type        = string
  description = "The location (zone or region) for the node pool."
}

variable "name" {
  type        = string
  description = "The name of the node pool."
}

variable "version" {
  type        = string
  description = "The Kubernetes version for nodes in the pool."
}

variable "initial_node_count" {
  type        = number
  description = "Initial number of nodes for the node pool."
}

variable "node_count" {
  type        = number
  description = "Desired number of nodes in the node pool."
}

variable "node_locations" {
  type        = list(string)
  description = "List of zones where the node pool will be located."
}

variable "autoscaling" {
  description = "Autoscaling settings for the node pool."
  type = object({
    location_policy      = string
    total_max_node_count = number
  })
}

variable "management" {
  description = "Node management settings."
  type = object({
    auto_repair  = bool
    auto_upgrade = bool
  })
}

variable "network_config" {
  description = "Network configuration for the node pool."
  type = object({
    enable_private_nodes = bool
    pod_ipv4_cidr_block  = string
    pod_range            = string
  })
}

variable "node_config" {
  description = "Node configuration block for the node pool."
  type = object({
    advanced_machine_features = object({
      threads_per_core = number
    })
    disk_size_gb    = number
    disk_type       = string
    image_type      = string
    logging_variant = string
    machine_type    = string
    metadata        = map(string)
    oauth_scopes    = list(string)
    service_account = string
    shielded_instance_config = object({
      enable_integrity_monitoring = bool
    })
    spot = bool
  })
}

variable "upgrade_settings" {
  description = "Settings controlling node upgrades."
  type = object({
    max_surge = number
    strategy  = string
  })
}
