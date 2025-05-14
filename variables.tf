variable "project_id" {
  description = "The project ID to deploy resources"
  type        = string
}

variable "location" {
  description = "The location (zone or region) for resources"
  type        = string
}

variable "region" {
  description = "The region for resources"
  type        = string
}

variable "format" {
  description = "The format for artifact registries"
  type        = string
}

variable "mode" {
  description = "The mode for artifact registries"
  type        = string
}

variable "repositories" {
  description = "Map of artifact registry repositories"
  type = map(object({
    repository_id          = string
    description            = string
    cleanup_policy_dry_run = bool
  }))
}

variable "addresses" {
  description = "Map of compute addresses"
  type = map(object({
    name         = string
    address      = string
    address_type = string
    network_tier = string
    purpose      = string
  }))
}

variable "firewalls" {
  description = "Map of firewall rules"
  type = map(object({
    name          = string
    network       = string
    direction     = string
    priority      = number
    source_ranges = list(string)
    target_tags   = optional(list(string), [])
    allow = list(object({
      protocol = string
      ports    = optional(list(string))
    }))
    description = string
  }))
}

variable "buckets" {
  description = "Map of storage buckets"
  type = map(object({
    name                        = string
    location                    = string
    storage_class               = string
    force_destroy               = bool
    public_access_prevention    = string
    uniform_bucket_level_access = bool
    cors = optional(list(object({
      max_age_seconds = number
      method          = list(string)
      origin          = list(string)
      response_header = list(string)
    })))
    # encryption = optional(object({
    #   default_kms_key_name = string
    # }))
    logging = optional(object({
      log_bucket        = string
      log_object_prefix = string
    }))
  }))
}

variable "service_accounts" {
  description = "Map of service accounts"
  type = map(object({
    account_id   = string
    display_name = string
    description  = string
  }))
}

variable "routers" {
  description = "Map of compute routers"
  type = map(object({
    name    = string
    network = string
  }))
}

# variable "key_rings" {
#   description = "Map of KMS key rings"
#   type = map(object({
#     name = string
#   }))
# }

variable "clusters" {
  description = "Map of GKE cluster configurations"
  type = map(object({
    name       = string
    location   = string
    network    = string
    subnetwork = string
    node_config = object({
      disk_size_gb    = number
      disk_type       = string
      image_type      = string
      logging_variant = string
      machine_type    = string
      metadata        = map(string)
      oauth_scopes    = list(string)
      service_account = string
      labels          = map(string)
      tags            = list(string)
      shielded_instance_config = object({
        enable_integrity_monitoring = bool
      })
      workload_metadata_config = object({
        mode = string
      })
    })
    ip_allocation_policy = object({
      cluster_secondary_range_name  = string
      services_secondary_range_name = string
      stack_type                    = string
      pod_cidr_overprovision_config = object({
        disabled = bool
      })
      cluster_ipv4_cidr_block  = optional(string)
      services_ipv4_cidr_block = optional(string)
      additional_pod_ranges_config = optional(object({
        pod_range_names = list(string)
      }))
    })
    addons_config = object({
      dns_cache_config = object({
        enabled = bool
      })
      gce_persistent_disk_csi_driver_config = object({
        enabled = bool
      })
      horizontal_pod_autoscaling = object({
        disabled = bool
      })
      http_load_balancing = object({
        disabled = bool
      })
      network_policy_config = object({
        disabled = bool
      })
    })
    cluster_autoscaling = object({
      autoscaling_profile = string
    })
    cluster_telemetry = object({
      type = string
    })
    database_encryption = object({
      state = string
    })
    default_max_pods_per_node = number
    default_snat_status = object({
      disabled = bool
    })
    description           = string
    enable_shielded_nodes = bool
    initial_node_count    = number
    logging_config = object({
      enable_components = list(string)
    })
    maintenance_policy = object({
      recurring_window = object({
        end_time   = string
        recurrence = string
        start_time = string
      })
    })
    master_auth = object({
      client_certificate_config = object({
        issue_client_certificate = bool
      })
    })
    master_authorized_networks_config = object({
      cidr_blocks = list(object({
        cidr_block   = string
        display_name = string
      }))
    })
    #min_master_version = string
    monitoring_config = object({
      advanced_datapath_observability_config = object({
        enable_metrics = bool
        enable_relay   = bool
      })
      enable_components = list(string)
    })
    network_policy = object({
      enabled  = bool
      provider = string
    })
    networking_mode = string
    node_pool_defaults = object({
      node_config_defaults = object({
        logging_variant = string
      })
    })
    node_version = string
    notification_config = object({
      pubsub = object({
        enabled = bool
      })
    })
    pod_security_policy_config = object({
      enabled = bool
    })
    private_cluster_config = object({
      enable_private_nodes   = bool
      master_ipv4_cidr_block = string
      master_global_access_config = object({
        enabled = bool
      })
    })
    protect_config = object({
      workload_config = object({
        audit_mode = string
      })
      workload_vulnerability_mode = string
    })
    release_channel = object({
      channel = string
    })
    security_posture_config = object({
      mode               = string
      vulnerability_mode = string
    })
    service_external_ips_config = object({
      enabled = bool
    })
    vertical_pod_autoscaling = object({
      enabled = bool
    })
    workload_identity_config = object({
      workload_pool = string
    })
  }))
}