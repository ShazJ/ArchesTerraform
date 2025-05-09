variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
  default     = "coral-370212" #sji coral-370212
}

variable "location" {
  description = "The location for Artifact Registry and KMS Key Rings"
  type        = string
  default     = "europe-west2"
}

variable "region" {
  description = "The region for Compute resources"
  type        = string
  default     = "europe-west2"
}

variable "format" {
  description = "The format of the repositories (e.g., DOCKER)"
  type        = string
  default     = "DOCKER"
}

variable "mode" {
  description = "The mode of the repositories (e.g., STANDARD_REPOSITORY)"
  type        = string
  default     = "STANDARD_REPOSITORY"
}

variable "repositories" {
  description = "Map of repository configurations"
  type = map(object({
    repository_id          = string
    description            = string
    cleanup_policy_dry_run = optional(bool, false)
  }))
  default = {
    arches = {
      repository_id          = "arches"
      description            = "Core Arches images for Coral (see *static* for deployable)"
      cleanup_policy_dry_run = true
    },
    arches_prd = {
      repository_id = "arches-prd"
      description   = "Core Arches images for Coral (see *static* for deployable)"
    },
    archesdata_prd = {
      repository_id = "archesdata-prd"
      description   = "Core Arches images for Coral (see *static* for deployable)"
    }
  }
}

variable "addresses" {
  description = "Map of Compute Address configurations"
  type = map(object({
    name         = string
    address      = string
    address_type = string
    network_tier = string
    purpose      = optional(string)
  }))
  default = {
    istio_prd = {
      name         = "istio-default-ingress-coral-prd"
      address      = "34.142.75.32"
      address_type = "EXTERNAL"
      network_tier = "PREMIUM"
    },
    istio_stg = {
      name         = "istio-default-ingress-coral-stg"
      address      = "34.89.106.198"
      address_type = "EXTERNAL"
      network_tier = "PREMIUM"
    },
    nat_auto_1 = {
      name         = "nat-auto-ip-6086885-2-1720490595712813"
      address      = "34.147.134.205"
      address_type = "EXTERNAL"
      network_tier = "PREMIUM"
      purpose      = "NAT_AUTO"
    },
    nat_auto_2 = {
      name         = "nat-auto-ip-15970522-0-1676784907194161"
      address      = "35.234.135.79"
      address_type = "EXTERNAL"
      network_tier = "PREMIUM"
      purpose      = "NAT_AUTO"
    }
  }
}

variable "firewalls" {
  description = "Map of Compute Firewall configurations"
  type = map(object({
    name          = string
    network       = string
    direction     = string
    priority      = number
    source_ranges = list(string)
    target_tags   = optional(list(string))
    description   = optional(string)
    allow = list(object({
      protocol = string
      ports    = optional(list(string))
    }))
  }))
  default = {
    coral_prd = {
      name          = "allow-ingress-coral-prd"
      network       = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network-prd"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["172.16.0.0/28"]
      target_tags   = ["gke-k8s-coral-prd-np-tf-8r35wt"]
      allow = [{
        protocol = "tcp"
        ports    = ["10250", "443", "15017", "8080", "15000"]
      }]
    },
    coral_stg = {
      name          = "allow-ingress-coral-stg"
      network       = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["172.16.0.0/28"]
      target_tags   = ["gke-k8s-coral-stg-np-tf-cejctx"]
      allow = [{
        protocol = "tcp"
        ports    = ["10250", "443", "15017", "8080", "15000"]
      }]
    },
    default_icmp = {
      name          = "default-allow-icmp"
      network       = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/default"
      direction     = "INGRESS"
      priority      = 65534
      source_ranges = ["0.0.0.0/0"]
      description   = "Allow ICMP from anywhere"
      allow = [{
        protocol = "icmp"
      }]
    },
    default_internal = {
      name          = "default-allow-internal"
      network       = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/default"
      direction     = "INGRESS"
      priority      = 65534
      source_ranges = ["10.128.0.0/9"]
      description   = "Allow internal traffic on the default network"
      allow = [
        {
          protocol = "tcp"
          ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
        },
        {
          protocol = "icmp"
        }
      ]
    }
  }
}

variable "buckets" {
  description = "Map of Storage Bucket configurations"
  type = map(object({
    name                        = string
    location                    = string
    storage_class               = string
    force_destroy               = bool
    public_access_prevention    = string
    uniform_bucket_level_access = bool
    cors = optional(list(object({
      max_age_seconds = optional(number)
      method          = list(string)
      origin          = list(string)
      response_header = optional(list(string))
    })))
    encryption = optional(object({
      default_kms_key_name = string
    }))
    logging = optional(object({
      log_bucket        = string
      log_object_prefix = string
    }))
  }))
  default = {
    data_store_prd = {
      name                        = "crl-data-store-prd-eu-west-2-flax"
      location                    = "EUROPE-WEST2"
      storage_class               = "STANDARD"
      force_destroy               = false
      public_access_prevention    = "enforced"
      uniform_bucket_level_access = true
    },
    data_store_uat_prd = {
      name                        = "crl-data-store-uat-eu-west-2-prd"
      location                    = "EUROPE-WEST2"
      storage_class               = "STANDARD"
      force_destroy               = false
      public_access_prevention    = "inherited"
      uniform_bucket_level_access = true
      cors = [{
        max_age_seconds = 3600
        method          = ["GET"]
        origin          = ["https://coral-her.flaxandteal.co.uk"]
        response_header = ["Content-Type"]
      }]
      encryption = {
        default_kms_key_name = "projects/coral-370212/locations/europe-west2/keyRings/data-store-keyring-uat-prd/cryptoKeys/data-store-key-uat-prd"
      }
      logging = {
        log_bucket        = "log-store-eu-west-2"
        log_object_prefix = "crl-data-store-uat-eu-west-2-prd"
      }
    },
    data_store_uat = {
      name                        = "crl-data-store-uat-eu-west-2"
      location                    = "EUROPE-WEST2"
      storage_class               = "STANDARD"
      force_destroy               = false
      public_access_prevention    = "enforced"
      uniform_bucket_level_access = true
      cors = [{
        max_age_seconds = 3600
        method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
        origin          = ["https://coral-uat.flaxandteal.co.uk"]
        response_header = ["*"]
      }]
      encryption = {
        default_kms_key_name = "projects/coral-370212/locations/europe-west2/keyRings/data-store-keyring-uat/cryptoKeys/data-store-key-uat"
      }
      logging = {
        log_bucket        = "log-store-eu-west-2"
        log_object_prefix = "crl-data-store-uat-eu-west-2"
      }
    },
    log_store_prd = {
      name                        = "crl-log-store-eu-west-2-prd"
      location                    = "EUROPE-WEST2"
      storage_class               = "STANDARD"
      force_destroy               = false
      public_access_prevention    = "inherited"
      uniform_bucket_level_access = true
    },
    prd_state_store_uat = {
      name                        = "crl-prd-state-store-uat-eu-west-2"
      location                    = "EUROPE-WEST2"
      storage_class               = "STANDARD"
      force_destroy               = false
      public_access_prevention    = "inherited"
      uniform_bucket_level_access = true
      encryption = {
        default_kms_key_name = "projects/coral-370212/locations/europe-west2/keyRings/data-store-keyring-uat-prd/cryptoKeys/data-store-key-uat-prd"
      }
    },
    state_store_uat = {
      name                        = "crl-state-store-uat-eu-west-2"
      location                    = "EUROPE-WEST2"
      storage_class               = "STANDARD"
      force_destroy               = false
      public_access_prevention    = "inherited"
      uniform_bucket_level_access = true
      encryption = {
        default_kms_key_name = "projects/coral-370212/locations/europe-west2/keyRings/data-store-keyring-uat/cryptoKeys/data-store-key-uat"
      }
    },
    artifacts_us = {
      name                        = "artifacts.coral-370212.appspot.com"
      location                    = "US"
      storage_class               = "STANDARD"
      force_destroy               = false
      public_access_prevention    = "inherited"
      uniform_bucket_level_access = false
    },
    artifacts_eu = {
      name                        = "eu.artifacts.coral-370212.appspot.com"
      location                    = "EU"
      storage_class               = "STANDARD"
      force_destroy               = false
      public_access_prevention    = "inherited"
      uniform_bucket_level_access = false
    }
  }
}

variable "service_accounts" {
  description = "Map of Service Account configurations"
  type = map(object({
    account_id   = string
    display_name = string
    description  = optional(string)
  }))
  default = {
    arches_k8s_prd = {
      account_id   = "coral-arches-k8s-coral-prd"
      display_name = "coral-arches-k8s coral-prd"
      description  = "Its IAM role(s) will specify the access-levels that the GKE node(s) may have"
    },
    arches_k8s_stg = {
      account_id   = "coral-arches-k8s-coral-stg"
      display_name = "coral-arches-k8s coral-stg"
      description  = "Its IAM role(s) will specify the access-levels that the GKE node(s) may have"
    },
    arches_uat_prd = {
      account_id   = "coral-arches-uat-prd"
      display_name = "Coral Production Arches Service Account"
    },
    arches_uat = {
      account_id   = "coral-arches-uat"
      display_name = "Coral Production Arches Service Account"
    },
    ci_prd = {
      account_id   = "coral-ci-prd"
      display_name = "Coral Production Arches Service Account"
    },
    ci = {
      account_id   = "coral-ci"
      display_name = "Coral Production Arches Service Account"
    },
    flux_prd = {
      account_id   = "coral-flux-prd"
      display_name = "Coral Production Flux Service Account"
    },
    gl_ci_prd = {
      account_id   = "coral-gl-ci-prd"
      display_name = "Coral Production Data Operations Service Account"
    }
  }
}

variable "routers" {
  description = "Map of Compute Router configurations"
  type = map(object({
    name    = string
    network = string
  }))
  default = {
    prd = {
      name    = "coral-network-router-prd"
      network = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network-prd"
    },
    stg = {
      name    = "coral-network-router"
      network = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network"
    }
  }
}

variable "routes" {
  description = "Map of Compute Route configurations"
  type = map(object({
    name        = string
    network     = string
    dest_range  = string
    priority    = number
    description = string
    #    next_hop_gateway = string
  }))
  default = {
    peering_2d78a0e4bac140d8 = {
      name        = "peering-route-2d78a0e4bac140d8"
      network     = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network"
      dest_range  = "172.16.0.0/28"
      priority    = 0
      description = "Auto generated route via peering [gke-n3160d8fda93cc2900d2-6468-d2c7-peer]."
      #      next_hop_gateway = "projects/coral-370212/global/gateways/default-internet-gateway"
    },
    peering_6417c1f2b7f61256 = {
      name        = "peering-route-6417c1f2b7f61256"
      network     = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network-prd"
      dest_range  = "172.16.0.0/28"
      priority    = 0
      description = "Auto generated route via peering [gke-n23223a9b66f638c4458-6e24-4f83-peer]."
      #      next_hop_gateway = "projects/coral-370212/global/gateways/default-internet-gateway"
    }
  }
}

variable "key_rings" {
  description = "Map of KMS Key Ring configurations"
  type = map(object({
    name = string
  }))
  default = {
    data_store_uat_prd = {
      name = "data-store-keyring-uat-prd"
    },
    data_store_uat = {
      name = "data-store-keyring-uat"
    },
    terraform_state = {
      name = "terraform-state-keyring"
    }
  }
}

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
      shielded_instance_config = object({
        enable_integrity_monitoring = bool
      })
      labels = optional(map(string))
      tags   = optional(list(string))
      advanced_machine_features = optional(object({
        threads_per_core = number
      }))
      workload_metadata_config = optional(object({
        mode          = string
        node_metadata = string
      }))
    })
    ip_allocation_policy = object({
      cluster_ipv4_cidr_block       = string
      services_ipv4_cidr_block      = string
      cluster_secondary_range_name  = string
      services_secondary_range_name = string
      stack_type                    = string
      pod_cidr_overprovision_config = object({
        disabled = bool
      })
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
    monitoring_config = object({
      advanced_datapath_observability_config = object({
        enable_metrics = bool
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
    workload_identity_config = optional(object({
      workload_pool = string
    }))
  }))
  default = {
    prd = {
      name       = "k8s-coral-prd"
      location   = "europe-west2-a"
      network    = "projects/coral-370212/global/networks/coral-network-prd"
      subnetwork = "projects/coral-370212/regions/europe-west2/subnetworks/coral-subnetwork-prd"
      node_config = {
        disk_size_gb    = 50
        disk_type       = "pd-balanced"
        image_type      = "COS_CONTAINERD"
        logging_variant = "DEFAULT"
        machine_type    = "e2-standard-8"
        metadata = {
          disable-legacy-endpoints = "true"
        }
        oauth_scopes = [
          "https://www.googleapis.com/auth/devstorage.read_only",
          "https://www.googleapis.com/auth/logging.write",
          "https://www.googleapis.com/auth/monitoring",
          "https://www.googleapis.com/auth/service.management.readonly",
          "https://www.googleapis.com/auth/servicecontrol",
          "https://www.googleapis.com/auth/trace.append"
        ]
        service_account = "default"
        shielded_instance_config = {
          enable_integrity_monitoring = true
        }
        advanced_machine_features = {
          threads_per_core = 0
        }
        workload_metadata_config = {
          mode          = "GKE_METADATA"
          node_metadata = "GKE_METADATA_SERVER"
        }
      }
      ip_allocation_policy = {
        cluster_ipv4_cidr_block       = "192.168.64.0/20"
        services_ipv4_cidr_block      = "192.168.0.0/20"
        cluster_secondary_range_name  = "pod-ranges"
        services_secondary_range_name = "services-range"
        stack_type                    = "IPV4"
        pod_cidr_overprovision_config = {
          disabled = false
        }
        additional_pod_ranges_config = {
          pod_range_names = ["gke-coral-cluster-pods-f3c8dd1b"]
        }
      }
      addons_config = {
        dns_cache_config = {
          enabled = true
        }
        gce_persistent_disk_csi_driver_config = {
          enabled = true
        }
        horizontal_pod_autoscaling = {
          disabled = false
        }
        http_load_balancing = {
          disabled = false
        }
        network_policy_config = {
          disabled = true
        }
      }
      cluster_autoscaling = {
        autoscaling_profile = "BALANCED"
      }
      cluster_telemetry = {
        type = "ENABLED"
      }
      database_encryption = {
        state = "DECRYPTED"
      }
      default_max_pods_per_node = 8
      default_snat_status = {
        disabled = false
      }
      description           = "Generated by Terraform"
      enable_shielded_nodes = true
      initial_node_count    = 1
      logging_config = {
        enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
      }
      maintenance_policy = {
        recurring_window = {
          end_time   = "2021-01-02T07:00:00Z"
          recurrence = "FREQ=WEEKLY;BYDAY=FR"
          start_time = "2021-01-01T19:00:00Z"
        }
      }
      master_auth = {
        client_certificate_config = {
          issue_client_certificate = false
        }
      }
      master_authorized_networks_config = {
        cidr_blocks = [
          {
            cidr_block   = "31.51.55.181/32"
            display_name = "F&T VPN"
          },
          {
            cidr_block   = "31.94.6.67/32"
            display_name = "PTW1"
          },
          {
            cidr_block   = "31.94.66.14/32"
            display_name = "Cloudshell"
          },
          {
            cidr_block   = "35.214.39.113/32"
            display_name = "F&T VPN"
          }
        ]
      }
      monitoring_config = {
        advanced_datapath_observability_config = {
          enable_metrics = false
        }
        enable_components = ["SYSTEM_COMPONENTS"]
      }
      network_policy = {
        enabled  = false
        provider = "PROVIDER_UNSPECIFIED"
      }
      networking_mode = "VPC_NATIVE"
      node_pool_defaults = {
        node_config_defaults = {
          logging_variant = "DEFAULT"
        }
      }
      node_version = "1.31.6-gke.1020000"
      notification_config = {
        pubsub = {
          enabled = false
        }
      }
      pod_security_policy_config = {
        enabled = false
      }
      private_cluster_config = {
        enable_private_nodes   = true
        master_ipv4_cidr_block = "172.16.0.0/28"
        master_global_access_config = {
          enabled = false
        }
      }
      protect_config = {
        workload_config = {
          audit_mode = "MODE_UNSPECIFIED"
        }
        workload_vulnerability_mode = "WORKLOAD_VULNERABILITY_MODE_UNSPECIFIED"
      }
      release_channel = {
        channel = "REGULAR"
      }
      security_posture_config = {
        mode               = "MODE_UNSPECIFIED"
        vulnerability_mode = "VULNERABILITY_MODE_UNSPECIFIED"
      }
      service_external_ips_config = {
        enabled = false
      }
      vertical_pod_autoscaling = {
        enabled = false
      }
      workload_identity_config = {
        workload_pool = "coral-370212.svc.id.goog"
      }
    },
    stg = {
      name       = "k8s-coral-stg"
      location   = "europe-west2-a"
      network    = "projects/coral-370212/global/networks/coral-network"
      subnetwork = "projects/coral-370212/regions/europe-west2/subnetworks/coral-subnetwork"
      node_config = {
        disk_size_gb    = 50
        disk_type       = "pd-standard"
        image_type      = "COS_CONTAINERD"
        logging_variant = "DEFAULT"
        machine_type    = "e2-standard-8"
        metadata = {
          disable-legacy-endpoints = "true"
        }
        oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
        service_account = "coral-arches-k8s-coral-stg@coral-370212.iam.gserviceaccount.com"
        shielded_instance_config = {
          enable_integrity_monitoring = true
        }
        labels = {
          TF_used_by  = "k8s-coral-stg"
          TF_used_for = "gke"
        }
        tags = ["gke-k8s-coral-stg-np-tf-cejctx"]
      }
      ip_allocation_policy = {
        cluster_ipv4_cidr_block       = "192.168.64.0/20"
        services_ipv4_cidr_block      = "192.168.0.0/20"
        cluster_secondary_range_name  = "pod-ranges"
        services_secondary_range_name = "services-range"
        stack_type                    = "IPV4"
        pod_cidr_overprovision_config = {
          disabled = false
        }
      }
      addons_config = {
        dns_cache_config = {
          enabled = true
        }
        gce_persistent_disk_csi_driver_config = {
          enabled = true
        }
        horizontal_pod_autoscaling = {
          disabled = false
        }
        http_load_balancing = {
          disabled = false
        }
        network_policy_config = {
          disabled = true
        }
      }
      cluster_autoscaling = {
        autoscaling_profile = "BALANCED"
      }
      cluster_telemetry = {
        type = "ENABLED"
      }
      database_encryption = {
        state = "DECRYPTED"
      }
      default_max_pods_per_node = 8
      default_snat_status = {
        disabled = false
      }
      description           = "Generated by Terraform"
      enable_shielded_nodes = true
      initial_node_count    = 1
      logging_config = {
        enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
      }
      maintenance_policy = {
        recurring_window = {
          end_time   = "2021-01-01T23:00:00Z"
          recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
          start_time = "2021-01-01T19:00:00Z"
        }
      }
      master_auth = {
        client_certificate_config = {
          issue_client_certificate = false
        }
      }
      master_authorized_networks_config = {
        cidr_blocks = [
          {
            cidr_block   = "31.94.20.141/32"
            display_name = "PTW"
          },
          {
            cidr_block   = "31.94.6.67/32"
            display_name = "SMH"
          },
          {
            cidr_block   = "35.214.39.113/32"
            display_name = "F&T VPN"
          }
        ]
      }
      monitoring_config = {
        advanced_datapath_observability_config = {
          enable_metrics = false
        }
        enable_components = ["SYSTEM_COMPONENTS"]
      }
      network_policy = {
        enabled  = false
        provider = "PROVIDER_UNSPECIFIED"
      }
      networking_mode = "VPC_NATIVE"
      node_pool_defaults = {
        node_config_defaults = {
          logging_variant = "DEFAULT"
        }
      }
      node_version = "1.31.6-gke.1020000"
      notification_config = {
        pubsub = {
          enabled = false
        }
      }
      pod_security_policy_config = {
        enabled = false
      }
      private_cluster_config = {
        enable_private_nodes   = true
        master_ipv4_cidr_block = "172.16.0.0/28"
        master_global_access_config = {
          enabled = false
        }
      }
      protect_config = {
        workload_config = {
          audit_mode = "MODE_UNSPECIFIED"
        }
        workload_vulnerability_mode = "WORKLOAD_VULNERABILITY_MODE_UNSPECIFIED"
      }
      release_channel = {
        channel = "UNSPECIFIED"
      }
      security_posture_config = {
        mode               = "MODE_UNSPECIFIED"
        vulnerability_mode = "VULNERABILITY_MODE_UNSPECIFIED"
      }
      service_external_ips_config = {
        enabled = false
      }
      vertical_pod_autoscaling = {
        enabled = false
      }
    }
  }
}