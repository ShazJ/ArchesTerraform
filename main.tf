#sji keys removed following
# data "google_project" "project" {
#   project_id = var.project_id
# }

module "artifact_registry" {
  for_each               = var.repositories
  source                 = "./modules/artifact_registry"
  project_id             = var.project_id
  repository_id          = each.value.repository_id
  location               = var.location
  description            = each.value.description
  format                 = var.format
  mode                   = var.mode
  cleanup_policy_dry_run = each.value.cleanup_policy_dry_run
}

module "compute_address" {
  for_each     = var.addresses
  source       = "./modules/compute_address"
  project_id   = var.project_id
  region       = var.region
  name         = each.value.name
  address      = each.value.address
  address_type = each.value.address_type
  network_tier = each.value.network_tier
  purpose      = each.value.purpose
}

module "compute_firewall" {
  depends_on    = [module.compute_subnetwork, module.compute_subnetwork_prd]
  for_each      = var.firewalls
  source        = "./modules/compute_firewall"
  project_id    = var.project_id
  name          = each.value.name
  network       = each.value.network
  direction     = each.value.direction
  priority      = each.value.priority
  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags
  allow         = each.value.allow
  description   = each.value.description
}

# resource "google_compute_network" "network" {
#   for_each = {
#     prd = "coral-network-prd"
#     stg = "coral-network"
#   }
#   project                 = var.project_id
#   name                    = each.value
#   auto_create_subnetworks = false
# }

# resource "google_compute_subnetwork" "subnetwork" {
#   for_each = {
#     prd = "coral-subnetwork-prd"
#     stg = "coral-subnetwork"
#   }
#   project       = var.project_id
#   name          = each.value
#   network       = google_compute_network.network[each.key].name
#   region        = var.region
#   ip_cidr_range = "10.0.0.0/16" # Adjust as needed
# }

module "storage_bucket" {
  for_each                    = var.buckets
  source                      = "./modules/storage_bucket"
  project_id                  = var.project_id
  name                        = each.value.name
  location                    = each.value.location
  storage_class               = each.value.storage_class
  force_destroy               = each.value.force_destroy
  public_access_prevention    = each.value.public_access_prevention
  uniform_bucket_level_access = each.value.uniform_bucket_level_access
  cors                        = each.value.cors
  # encryption                  = each.value.encryption
  logging = each.value.logging
}

module "service_account" {
  for_each              = var.service_accounts
  source                = "./modules/service_account"
  project_id            = var.project_id
  account_id            = each.value.account_id
  display_name          = each.value.display_name
  description           = each.value.description
  service_account_email = var.service_account_email
}

module "compute_network_prd" {
  source                                    = "./modules/compute_network"
  project_id                                = var.project_id
  name                                      = "coral-network-prd"
  auto_create_subnetworks                   = false
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

module "compute_network" {
  source                                    = "./modules/compute_network"
  project_id                                = var.project_id
  name                                      = "coral-network"
  auto_create_subnetworks                   = false
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

module "compute_subnetwork_prd" {
  source                     = "./modules/compute_subnetwork"
  project_id                 = var.project_id
  name                       = "coral-subnetwork-prd"
  network                    = module.compute_network_prd.network_self_link
  region                     = var.region
  ip_cidr_range              = "10.2.0.0/16"
  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  purpose                    = "PRIVATE"
  stack_type                 = "IPV4_ONLY"
  secondary_ip_ranges = [
    {
      range_name    = "services-range"
      ip_cidr_range = "192.168.0.0/20"
    },
    {
      range_name    = "pod-ranges"
      ip_cidr_range = "192.168.64.0/20"
    },
    {
      range_name    = "gke-coral-cluster-pods-f3c8dd1b"
      ip_cidr_range = "10.196.0.0/14"
    },
    {
      range_name    = "gke-coral-cluster-services-f3c8dd1b"
      ip_cidr_range = "10.200.0.0/20"
    }
  ]
}

module "compute_subnetwork" {
  depends_on = [ module.compute_network, module.compute_network_prd]
  source                     = "./modules/compute_subnetwork"
  project_id                 = var.project_id
  name                       = "coral-subnetwork"
  network                    = module.compute_network.network_self_link
  region                     = var.region
  ip_cidr_range              = "10.2.0.0/16"
  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  purpose                    = "PRIVATE"
  stack_type                 = "IPV4_ONLY"
  secondary_ip_ranges = [
    {
      range_name    = "services-range"
      ip_cidr_range = "192.168.0.0/20"
    },
    {
      range_name    = "pod-ranges"
      ip_cidr_range = "192.168.64.0/20"
    },
    {
      range_name    = "gke-coral-cluster-pods-f3c8dd1b"
      ip_cidr_range = "10.196.0.0/14"
    },
    {
      range_name    = "gke-coral-cluster-services-f3c8dd1b"
      ip_cidr_range = "10.200.0.0/20"
    }
  ]
}

module "compute_router" {
  for_each   = var.routers
  source     = "./modules/compute_router"
  project_id = var.project_id
  name       = each.value.name
  network    = each.value.network
  region     = var.region
  depends_on = [module.compute_network, module.compute_network_prd]
}

# # Cloud NAT
# module "compute_router" {
#   source                             = "./modules/compute_router"
#   project_id                         = var.project_id
#   region                             = var.region
#   name                               = "coral-network-router-prd"
#   router                             = module.compute_router.name
#   nat_ip_allocate_option             = "AUTO_ONLY"
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
#   depends_on                         = [module.compute_router]
# }
# module "compute_router_nat" {
#   source                             = "./modules/compute_router_nat"
#   project_id                         = var.project_id
#   region                             = var.region
#   name                               = "coral-network-router"
#   router                             = module.compute_router.name
#   nat_ip_allocate_option             = "AUTO_ONLY"
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
#   depends_on                         = [module.compute_router]
# }
# resource "google_compute_router_nat" "nat" {
#   for_each = {
#     prd = "coral-network-router-prd"
#     stg = "coral-network-router"
#   }
#   project                            = var.project_id
#   region                             = var.region
#   name                               = "${each.key}-nat"
#   router                             = each.value
#   nat_ip_allocate_option             = "AUTO_ONLY"
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
# }

module "compute_resource_policy" {
  source     = "./modules/compute_resource_policy"
  project_id = var.project_id
  name       = "coral-postgres"
  region     = var.region
  snapshot_schedule_policy = {
    retention_policy = {
      max_retention_days    = 14
      on_source_disk_delete = "APPLY_RETENTION_POLICY"
    }
    schedule = {
      daily_schedule = {
        days_in_cycle = 1
        start_time    = "19:00"
      }
    }
    snapshot_properties = {
      labels = {
        purpose = "db"
      }
      storage_locations = ["europe-west2"]
    }
  }
}

module "kms_key_ring" {
  for_each    = var.kms_key_rings
  source      = "./modules/kms"
  project_id  = var.project_id
  name        = each.value.name
  location    = each.value.location
  crypto_keys = each.value.crypto_keys
  labels      = each.value.labels
}

# module "kms_crypto_key" {
#   for_each   = var.crypto_keys
#   source     = "./modules/kms"
#   project_id = var.project_id
#   name       = each.value.name
#   key_ring   = module.kms_key_ring[each.key].key_ring_id
#   rotation_period = each.value.rotation_period
# }
# module "kms_key_ring_iam" {
#   for_each   = var.kms_key_ring_iam_bindings
#   source     = "./modules/kms"
#   project_id = var.project_id
#   key_ring   = module.kms_key_ring[each.key].key_ring_id
#   role       = each.value.role
#   members    = each.value.members
# }

module "container_cluster" {
  depends_on = [module.compute_subnetwork, module.compute_subnetwork_prd, module.service_account]
  for_each   = var.clusters
  source     = "./modules/container_cluster"
  project_id = var.project_id
  name       = each.value.name
  location   = each.value.location
  network    = each.value.network
  subnetwork = each.value.subnetwork
  node_config = {
    disk_size_gb    = each.value.node_config.disk_size_gb
    disk_type       = each.value.node_config.disk_type
    image_type      = each.value.node_config.image_type
    logging_variant = each.value.node_config.logging_variant
    machine_type    = each.value.node_config.machine_type
    metadata        = each.value.node_config.metadata
    oauth_scopes    = each.value.node_config.oauth_scopes
    service_account = each.value.node_config.service_account
    shielded_instance_config = {
      enable_integrity_monitoring = each.value.node_config.shielded_instance_config.enable_integrity_monitoring
    }
    labels                   = each.value.node_config.labels
    tags                     = each.value.node_config.tags
    workload_metadata_config = each.value.node_config.workload_metadata_config
  }
  ip_allocation_policy = {
    cluster_secondary_range_name  = each.value.ip_allocation_policy.cluster_secondary_range_name
    services_secondary_range_name = each.value.ip_allocation_policy.services_secondary_range_name
    stack_type                    = each.value.ip_allocation_policy.stack_type
    pod_cidr_overprovision_config = {
      disabled = each.value.ip_allocation_policy.pod_cidr_overprovision_config.disabled
    }
    additional_pod_ranges_config = each.value.ip_allocation_policy.additional_pod_ranges_config
  }
  addons_config = {
    dns_cache_config = {
      enabled = each.value.addons_config.dns_cache_config.enabled
    }
    gce_persistent_disk_csi_driver_config = {
      enabled = each.value.addons_config.gce_persistent_disk_csi_driver_config.enabled
    }
    horizontal_pod_autoscaling = {
      disabled = each.value.addons_config.horizontal_pod_autoscaling.disabled
    }
    http_load_balancing = {
      disabled = each.value.addons_config.http_load_balancing.disabled
    }
    network_policy_config = {
      disabled = each.value.addons_config.network_policy_config.disabled
    }
    # istio_config = {
    #   disabled = each.value.addons_config.istio_config.disabled
    #   auth     = each.value.addons_config.istio_config.auth
    # }
  }
  cluster_autoscaling = {
    autoscaling_profile = each.value.cluster_autoscaling.autoscaling_profile
  }
  cluster_telemetry = {
    type = each.value.cluster_telemetry.type
  }
  database_encryption = {
    state = each.value.database_encryption.state
  }
  default_max_pods_per_node = each.value.default_max_pods_per_node
  default_snat_status = {
    disabled = each.value.default_snat_status.disabled
  }
  description           = each.value.description
  enable_shielded_nodes = each.value.enable_shielded_nodes
  initial_node_count    = each.value.initial_node_count
  logging_config = {
    enable_components = each.value.logging_config.enable_components
  }
  maintenance_policy = {
    recurring_window = {
      end_time   = each.value.maintenance_policy.recurring_window.end_time
      recurrence = each.value.maintenance_policy.recurring_window.recurrence
      start_time = each.value.maintenance_policy.recurring_window.start_time
    }
  }
  master_auth = {
    client_certificate_config = {
      issue_client_certificate = each.value.master_auth.client_certificate_config.issue_client_certificate
    }
  }
  master_authorized_networks_config = {
    cidr_blocks = each.value.master_authorized_networks_config.cidr_blocks
  }
  monitoring_config = {
    advanced_datapath_observability_config = {
      enable_metrics = each.value.monitoring_config.advanced_datapath_observability_config.enable_metrics
      enable_relay   = each.value.monitoring_config.advanced_datapath_observability_config.enable_relay
    }
    enable_components = each.value.monitoring_config.enable_components
  }
  network_policy = {
    enabled  = each.value.network_policy.enabled
    provider = each.value.network_policy.provider
  }
  networking_mode = each.value.networking_mode
  node_pool_defaults = {
    node_config_defaults = {
      logging_variant = each.value.node_pool_defaults.node_config_defaults.logging_variant
    }
  }
  node_version       = each.value.node_version
  min_master_version = each.value.min_master_version
  notification_config = {
    pubsub = {
      enabled = each.value.notification_config.pubsub.enabled
    }
  }
  pod_security_policy_config = {
    enabled = each.value.pod_security_policy_config.enabled
  }
  private_cluster_config = {
    enable_private_nodes   = each.value.private_cluster_config.enable_private_nodes
    master_ipv4_cidr_block = each.value.private_cluster_config.master_ipv4_cidr_block
    master_global_access_config = {
      enabled = each.value.private_cluster_config.master_global_access_config.enabled
    }
  }
  protect_config = {
    workload_config = {
      audit_mode = each.value.protect_config.workload_config.audit_mode
    }
    workload_vulnerability_mode = each.value.protect_config.workload_vulnerability_mode
  }
  release_channel = {
    channel = each.value.release_channel.channel
  }
  security_posture_config = {
    mode               = each.value.security_posture_config.mode
    vulnerability_mode = each.value.security_posture_config.vulnerability_mode
  }
  service_external_ips_config = {
    enabled = each.value.service_external_ips_config.enabled
  }
  vertical_pod_autoscaling = {
    enabled = each.value.vertical_pod_autoscaling.enabled
  }
  workload_identity_config = each.value.workload_identity_config
}