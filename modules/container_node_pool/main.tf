resource "google_container_node_pool" "node_pool" {
  name               = var.name
  cluster            = var.cluster
  location           = var.location
  project            = var.project
  node_count         = var.node_count
  node_locations     = var.node_locations
  version            = var.version
  initial_node_count = var.initial_node_count

  autoscaling {
    location_policy      = var.autoscaling.location_policy
    total_max_node_count = var.autoscaling.total_max_node_count
  }

  management {
    auto_repair  = var.management.auto_repair
    auto_upgrade = var.management.auto_upgrade
  }

  network_config {
    enable_private_nodes = var.network_config.enable_private_nodes
    pod_ipv4_cidr_block  = var.network_config.pod_ipv4_cidr_block
    pod_range            = var.network_config.pod_range
  }

  node_config {
    advanced_machine_features {
      threads_per_core = var.node_config.advanced_machine_features.threads_per_core
    }

    disk_size_gb    = var.node_config.disk_size_gb
    disk_type       = var.node_config.disk_type
    image_type      = var.node_config.image_type
    logging_variant = var.node_config.logging_variant
    machine_type    = var.node_config.machine_type
    metadata        = var.node_config.metadata
    oauth_scopes    = var.node_config.oauth_scopes
    service_account = var.node_config.service_account

    shielded_instance_config {
      enable_integrity_monitoring = var.node_config.shielded_instance_config.enable_integrity_monitoring
    }

    spot = var.node_config.spot
  }

  upgrade_settings {
    max_surge = var.upgrade_settings.max_surge
    strategy  = var.upgrade_settings.strategy
  }
}
