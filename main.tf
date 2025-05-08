module "artifact_registry" {
  for_each               = var.repositories
  source                 = "./modules/artifact_registry"
  project_id             = var.project_id
  repository_id          = each.value.repository_id
  location               = var.location
  description            = each.value.description
  format                 = var.format
  mode                   = var.mode
  cleanup_policy_dry_run = lookup(each.value, "cleanup_policy_dry_run", false)
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
  purpose      = lookup(each.value, "purpose", null)
}

module "compute_firewall" {
  for_each      = var.firewalls
  source        = "./modules/compute_firewall"
  project_id    = var.project_id
  name          = each.value.name
  network       = each.value.network
  direction     = each.value.direction
  priority      = each.value.priority
  source_ranges = each.value.source_ranges
  target_tags   = lookup(each.value, "target_tags", [])
  allow         = each.value.allow
  description   = lookup(each.value, "description", null)
}

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
  cors                        = lookup(each.value, "cors", [])
  encryption                  = lookup(each.value, "encryption", null)
  logging                     = lookup(each.value, "logging", null)
}

module "service_account" {
  for_each     = var.service_accounts
  source       = "./modules/service_account"
  project_id   = var.project_id
  account_id   = each.value.account_id
  display_name = each.value.display_name
  description  = lookup(each.value, "description", null)
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
}

# module "compute_route" {
#   for_each    = var.routes
#   source      = "./modules/compute_route"
#   project_id  = var.project_id
#   name        = each.value.name
#   network     = each.value.network
#   dest_range  = each.value.dest_range
#   priority    = each.value.priority
#   description = each.value.description
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
  for_each   = var.key_rings
  source     = "./modules/kms_key_ring"
  project_id = var.project_id
  name       = each.value.name
  location   = var.location
}