resource "google_container_cluster" "cluster" {
  provider                  = google-beta
  project                   = var.project_id
  name                      = var.name
  location                  = var.location
  network                   = var.network
  subnetwork                = var.subnetwork
  initial_node_count        = var.initial_node_count
  description               = var.description
  enable_shielded_nodes     = var.enable_shielded_nodes
  default_max_pods_per_node = var.default_max_pods_per_node
  networking_mode           = var.networking_mode
  min_master_version        = var.min_master_version
  node_version              = var.node_version

  node_config {
    disk_size_gb    = var.node_config.disk_size_gb
    disk_type       = var.node_config.disk_type
    image_type      = var.node_config.image_type
    logging_variant = var.node_config.logging_variant
    machine_type    = var.node_config.machine_type
    metadata        = var.node_config.metadata
    oauth_scopes    = var.node_config.oauth_scopes
    service_account = var.node_config.service_account
    labels          = var.node_config.labels
    tags            = var.node_config.tags

    shielded_instance_config {
      enable_integrity_monitoring = var.node_config.shielded_instance_config.enable_integrity_monitoring
    }

    workload_metadata_config {
      mode = var.node_config.workload_metadata_config.mode
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_allocation_policy.cluster_secondary_range_name
    services_secondary_range_name = var.ip_allocation_policy.services_secondary_range_name
    stack_type                    = var.ip_allocation_policy.stack_type

    pod_cidr_overprovision_config {
      disabled = var.ip_allocation_policy.pod_cidr_overprovision_config.disabled
    }

    dynamic "additional_pod_ranges_config" {
      for_each = var.ip_allocation_policy.additional_pod_ranges_config != null && length(var.ip_allocation_policy.additional_pod_ranges_config.pod_range_names) > 0 ? [var.ip_allocation_policy.additional_pod_ranges_config] : []
      content {
        pod_range_names = additional_pod_ranges_config.value.pod_range_names
      }
    }
  }

  addons_config {
    dns_cache_config {
      enabled = var.addons_config.dns_cache_config.enabled
    }
    gce_persistent_disk_csi_driver_config {
      enabled = var.addons_config.gce_persistent_disk_csi_driver_config.enabled
    }
    horizontal_pod_autoscaling {
      disabled = var.addons_config.horizontal_pod_autoscaling.disabled
    }
    http_load_balancing {
      disabled = var.addons_config.http_load_balancing.disabled
    }
    network_policy_config {
      disabled = var.addons_config.network_policy_config.disabled
    }
    # istio_config {
    #   disabled = var.addons_config.istio_config.disabled
    #   auth     = var.addons_config.istio_config.auth
    # }
  }

  cluster_autoscaling {
    autoscaling_profile = var.cluster_autoscaling.autoscaling_profile
  }

  cluster_telemetry {
    type = var.cluster_telemetry.type
  }

  # database_encryption {
  #   state    = var.database_encryption.state
  #   key_name = var.database_encryption.key_name
  # }

  default_snat_status {
    disabled = var.default_snat_status.disabled
  }

  # logging_config {
  #   enable_components = var.logging_config.enable_components
  # }

  maintenance_policy {
    recurring_window {
      end_time   = var.maintenance_policy.recurring_window.end_time
      recurrence = var.maintenance_policy.recurring_window.recurrence
      start_time = var.maintenance_policy.recurring_window.start_time
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = var.master_auth.client_certificate_config.issue_client_certificate
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks_config.cidr_blocks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  # monitoring_config {
  #   dynamic "advanced_datapath_observability_config" {
  #     for_each = var.monitoring_config.advanced_datapath_observability_config != null ? [var.monitoring_config.advanced_datapath_observability_config] : []
  #     content {
  #       enable_metrics = advanced_datapath_observability_config.value.enable_metrics
  #       enable_relay   = advanced_datapath_observability_config.value.enable_relay
  #     }
  #   }
  #   enable_components = var.monitoring_config.enable_components
  # }

  network_policy {
    enabled  = var.network_policy.enabled
    provider = var.network_policy.provider
  }

  node_pool_defaults {
    node_config_defaults {
      logging_variant = var.node_pool_defaults.node_config_defaults.logging_variant
    }
  }

  notification_config {
    pubsub {
      enabled = var.notification_config.pubsub.enabled
    }
  }

  pod_security_policy_config {
    enabled = var.pod_security_policy_config.enabled
  }

  private_cluster_config {
    enable_private_nodes   = var.private_cluster_config.enable_private_nodes
    master_ipv4_cidr_block = var.private_cluster_config.master_ipv4_cidr_block
    master_global_access_config {
      enabled = var.private_cluster_config.master_global_access_config.enabled
    }
  }

  protect_config {
    workload_config {
      audit_mode = var.protect_config.workload_config.audit_mode
    }
    workload_vulnerability_mode = var.protect_config.workload_vulnerability_mode
  }

  release_channel {
    channel = var.release_channel.channel
  }

  security_posture_config {
    mode               = var.security_posture_config.mode
    vulnerability_mode = var.security_posture_config.vulnerability_mode
  }

  service_external_ips_config {
    enabled = var.service_external_ips_config.enabled
  }

  vertical_pod_autoscaling {
    enabled = var.vertical_pod_autoscaling.enabled
  }

  dynamic "workload_identity_config" {
    for_each = var.workload_identity_config != null ? [var.workload_identity_config] : []
    content {
      workload_pool = workload_identity_config.value.workload_pool
    }
  }
}