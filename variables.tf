variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
  default     = "coral-459111" #sji coral-370212
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
  }))
  default = {
    peering_2d78a0e4bac140d8 = {
      name        = "peering-route-2d78a0e4bac140d8"
      network     = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network"
      dest_range  = "172.16.0.0/28"
      priority    = 0
      description = "Auto generated route via peering [gke-n3160d8fda93cc2900d2-6468-d2c7-peer]."
    },
    peering_6417c1f2b7f61256 = {
      name        = "peering-route-6417c1f2b7f61256"
      network     = "https://www.googleapis.com/compute/v1/projects/coral-370212/global/networks/coral-network-prd"
      dest_range  = "172.16.0.0/28"
      priority    = 0
      description = "Auto generated route via peering [gke-n23223a9b66f638c4458-6e24-4f83-peer]."
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