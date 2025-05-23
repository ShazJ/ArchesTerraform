project_id = "coral-459111"
location   = "europe-west2"
region     = "europe-west2"
format     = "DOCKER"
mode       = "STANDARD_REPOSITORY"

repositories = {
  arches = {
    repository_id          = "arches"
    description            = "Core Arches images for Coral (see *static* for deployable)"
    cleanup_policy_dry_run = true
  },
  arches_prd = {
    repository_id          = "arches-prd"
    description            = "Core Arches images for Coral (see *static* for deployable)"
    cleanup_policy_dry_run = true
  },
  archesdata_prd = {
    repository_id          = "archesdata-prd"
    description            = "Core Arches images for Coral (see *static* for deployable)"
    cleanup_policy_dry_run = true
  }
}

addresses = {
  # istio_prd = {
  #   name         = "istio-prd" #"istio-default-ingress-coral-prd"
  #   address      = "34.142.75.32"
  #   address_type = "EXTERNAL"
  #   network_tier = "PREMIUM"
  #   purpose      = "" #"EXTERNAL"
  # },
  # istio_stg = {
  #   name         = "istio-stg" #"istio-default-ingress-coral-stg"
  #   address      = "34.89.106.198"
  #   address_type = "EXTERNAL"
  #   network_tier = "PREMIUM"
  #   purpose      = "" #"EXTERNAL"
  # },
  # nat_auto_1 = {
  #   name         = "nat-auto-ip-6086885-2-1720490595712813"
  #   address      = "34.147.134.205"
  #   address_type = "EXTERNAL"
  #   network_tier = "PREMIUM"
  #   purpose      = "NAT_AUTO"
  # },
  # nat_auto_2 = {
  #   name         = "nat-auto-ip-15970522-0-1676784907194161"
  #   address      = "35.234.135.79"
  #   address_type = "EXTERNAL"
  #   network_tier = "PREMIUM"
  #   purpose      = "NAT_AUTO"
  # }
}

firewalls = {
  letsencrpt_egress = {
    name      = "letsencrpt-egress"
    network   = "https://www.googleapis.com/compute/v1/projects/coral-459111/global/networks/coral-network"
    direction = "EGRESS"
    priority  = 1000
    allow = [{
      ports    = ["443"]
      protocol = "tcp"
    }]
    description = "Encrypt egress"
  },
  k8s_fw = {
    name               = "k8s-fw"
    network            = "https://www.googleapis.com/compute/v1/projects/coral-459111/global/networks/coral-network"
    direction          = "INGRESS"
    priority           = 1000
    destination_ranges = ["34.89.106.198"]
    source_ranges      = ["0.0.0.0/0"]
    target_tags        = ["gke-k8s-coral-stg-4b674dca-node"]
    description        = "{\"kubernetes.io/service-name\":\"istio-system/istio-gateway\", \"kubernetes.io/service-ip\":\"34.89.106.198\"}"
    allow = [{
      ports    = ["80", "443", "15021"]
      protocol = "tcp"
    }]
    description = "{\"kubernetes.io/service-name\":\"istio-system/istio-gateway\", \"kubernetes.io/service-ip\":\"34.142.75.32\"}"
  },
  coral_prd = {
    name          = "allow-ingress-coral-prd"
    network       = "https://www.googleapis.com/compute/v1/projects/coral-459111/global/networks/coral-network-prd"
    direction     = "INGRESS"
    priority      = 1000
    source_ranges = ["172.16.0.0/28"]
    target_tags   = ["gke-k8s-coral-prd-np-tf-8r35wt"]
    allow = [{
      protocol = "tcp"
      ports    = ["10250", "443", "15017", "8080", "15000"]
    }]
    description = "Allow ingress for Coral production GKE cluster"
  },
  coral_stg = {
    name          = "allow-ingress-coral-stg"
    network       = "https://www.googleapis.com/compute/v1/projects/coral-459111/global/networks/coral-network"
    direction     = "INGRESS"
    priority      = 1000
    source_ranges = ["172.16.0.0/28"]
    target_tags   = ["gke-k8s-coral-stg-np-tf-cejctx"]
    allow = [{
      protocol = "tcp"
      ports    = ["10250", "443", "15017", "8080", "15000"]
    }]
    description = "Allow ingress for Coral staging GKE cluster"
  },
  #   # default_icmp = {
  #   #   name          = "default-allow-icmp"
  #   #   network       = "https://www.googleapis.com/compute/v1/projects/coral-459111/global/networks/default"
  #   #   direction     = "INGRESS"
  #   #   priority      = 65534
  #   #   source_ranges = ["0.0.0.0/0"]
  #   #   target_tags   = []
  #   #   description   = "Allow ICMP from anywhere"
  #   #   allow = [{
  #   #     protocol = "icmp"
  #   #     ports    = []
  #   #   }]
  #   # },
  #   default_internal = {
  #     name          = "default-allow-internal"
  #     network       = "https://www.googleapis.com/compute/v1/projects/coral-459111/global/networks/default"
  #     direction     = "INGRESS"
  #     priority      = 65534
  #     source_ranges = ["10.128.0.0/9"]
  #     target_tags   = []
  #     description   = "Allow internal traffic on the default network"
  #     allow = [
  #       {
  #         protocol = "tcp"
  #         ports    = ["0-65535"]
  #       },
  #       {
  #         protocol = "udp"
  #         ports    = ["0-65535"]
  #       },
  #       {
  #         protocol = "icmp"
  #         ports    = []
  #       }
  #     ]
  #   }
}
#sji todo! bucket naming lol
buckets = {
  data_store_prd = {
    name                        = "sjicrl-data-store-prd-eu-west-2-flax"
    location                    = "EUROPE-WEST2"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "enforced"
    uniform_bucket_level_access = true
    cors                        = []
  },
  data_store_uat_prd = {
    name                        = "sjicrl-data-store-uat-eu-west-2-prd"
    location                    = "EUROPE-WEST2"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "inherited"
    uniform_bucket_level_access = true
    cors                        = []
    cors = [{
      max_age_seconds = 3600
      method          = ["GET"]
      origin          = ["https://coral-her.flaxandteal.co.uk"]
      response_header = ["Content-Type"]
    }]
    encryption = {
      default_kms_key_name = "projects/coral-459111/locations/europe-west2/keyRings/data-store-keyring-uat-prd/cryptoKeys/data-store-key-uat-prd"
    }
    logging = {
      log_bucket        = "log-store-eu-west-2"
      log_object_prefix = "sji.crl-data-store-uat-eu-west-2-prd"
    }
  },
  data_store_uat = {
    name                        = "sjicrl-data-store-uat-eu-west-2"
    location                    = "EUROPE-WEST2"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "enforced"
    uniform_bucket_level_access = true
    cors                        = []
    encryption                  = null
    cors = [{
      max_age_seconds = 3600
      method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
      origin          = ["https://coral-uat.flaxandteal.co.uk"]
      response_header = ["*"]
    }]
    encryption = {
      default_kms_key_name = "projects/coral-459111/locations/europe-west2/keyRings/data-store-keyring-uat/cryptoKeys/data-store-key-uat"
    }
    logging = {
      log_bucket        = "log-store-eu-west-2"
      log_object_prefix = "sji.crl-data-store-uat-eu-west-2"
    }
  },
  log_store_prd = {
    name                        = "sjicrl-log-store-eu-west-2-prd"
    location                    = "EUROPE-WEST2"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "inherited"
    uniform_bucket_level_access = true
    encryption                  = null
    cors                        = []
  },
  log_store = {
    name                        = "sjicrl-log-store-eu-west-2"
    location                    = "EUROPE-WEST2"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "inherited"
    uniform_bucket_level_access = true
    encryption                  = null
    cors                        = []
  },
  artifacts_us = {
    name                        = "sjiartifacts-coral-459111-appspot-com" #artifacts.coral-370212.appspot.com
    location                    = "US"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "inherited"
    uniform_bucket_level_access = false
    encryption                  = null
    cors                        = []
  },
  artifacts_eu = {
    name                        = "sjieu-artifacts-coral-459111-appspot-com" #eu.artifacts.coral-370212.appspot.com
    location                    = "EU"
    storage_class               = "STANDARD"
    force_destroy               = false
    public_access_prevention    = "inherited"
    uniform_bucket_level_access = false
    encryption                  = null
    cors                        = []
  }
}

service_accounts = {
  "arches_k8s_prd" = {
    account_id      = "coral-arches-k8s-coral-prd"
    display_name    = "Coral Production GKE Service Account"
    description     = "Service account for GKE cluster in production"
    allow_iam_roles = true
    roles = [
      "container.clusterAdmin",                    # Kubernetes Engine Cluster Admin
      "compute.viewer",                            # Compute Viewer
      "logging.logWriter",                         # Logs Writer
      "monitoring.metricWriter",                   # Monitoring Metric Writer
      "roles/artifactregistry.reader",             # Artifact Registry Reader
      "roles/artifactregistry.serviceAgent",       # Artifact Registry Service Agent
      "roles/source.reader",                       # Source Repository Reader
      "roles/source.serviceAgent",                 # Source Repository Service Agent
      "roles/container.nodeServiceAccount",        # Kubernetes Engine Node Service Account
      "roles/iam.serviceAccountTokenCreator",      # Service Account Token Creator 
      "roles/stackdriver.resourceMetadata.writer", # Stackdriver Resource Metadata Writer
      "roles/storage.objectViewer",                # Storage Object Viewer
      "roles/container.clusterAdmin",              # Kubernetes Engine Cluster Admin
      "roles/compute.viewer",                      # Compute Viewer
      "roles/logging.logWriter",                   # Logs Writer  
      "roles/monitoring.metricWriter"              # Monitoring Metric Writer 
    ]
  }
  "arches_k8s_stg" = {
    account_id      = "coral-arches-k8s-coral-stg"
    display_name    = "Coral Production GKE Service Account"
    description     = "Service account for GKE cluster in production"
    allow_iam_roles = true
    roles = [
      "roles/artifactregistry.reader",             # Artifact Registry Reader
      "roles/container.nodeServiceAccount",        # Kubernetes Engine Node Service Account
      "roles/logging.logWriter",                   # Logs Writer
      "roles/monitoring.metricWriter",             # Monitoring Metric Writer
      "roles/stackdriver.resourceMetadata.writer", # Stackdriver Resource Metadata Writer
      "roles/storage.objectViewer",                # Storage Object Viewer
      "roles/container.clusterAdmin",              # Kubernetes Engine Cluster Admin
      "roles/compute.viewer"                       # Compute Viewer    
    ]
  }
  "arches_uat_prd" = {
    account_id      = "coral-arches-uat-prd"
    display_name    = "Coral Production Arches Service Account"
    description     = "Service account for Coral production Arches"
    allow_iam_roles = false
    roles           = ["storage.objectAdmin"]
  }
  "arches_uat" = {
    account_id      = "coral-arches-uat"
    display_name    = "Coral UAT Arches Service Account"
    description     = "Service account for Coral UAT Arches"
    allow_iam_roles = false
    roles           = ["storage.objectAdmin", "cloudkms.cryptoKeyEncrypterDecrypter"]
  }
  "ci_prd" = {
    account_id      = "coral-ci-prd"
    display_name    = "Coral Production CI Service Account"
    description     = "Service account for CI in production"
    allow_iam_roles = false
    roles           = ["compute.admin", "storage.admin", "container.admin"]
  }
  "ci" = {
    account_id      = "coral-ci"
    display_name    = "Coral CI Service Account"
    description     = "Service account for CI"
    allow_iam_roles = true
    roles = [
      "roles/compute.admin",                      # Compute Engine Admin
      "roles/storage.admin",                      # Storage Admin
      "roles/iam.serviceAccountUser",             # Service Account User
      "roles/container.admin",                    # Kubernetes Engine Admin
      "roles/artifactregistry.admin",             # Artifact Registry Administrator
      "roles/cloudbuild.builds.builder",          # Cloud Build Service Account
      "roles/storage.objectAdmin",                # Storage Object Administrator
      "roles/composer.environmentAndStorageAdmin" # Environment and Storage Object Administrator
    ]
  }
  "flux_prd" = {
    account_id      = "coral-flux-prd"
    display_name    = "Coral Production Flux Service Account"
    description     = "Service account for Flux in production"
    allow_iam_roles = false
    roles           = ["container.developer", "cloudkms.cryptoKeyEncrypterDecrypter"]
  }
  "gl_ci_prd" = {
    account_id      = "coral-gl-ci-prd"
    display_name    = "Coral Production Data Operations Service Account"
    allow_iam_roles = false
    description     = "Service account for data operations in production"

    roles = ["bigquery.dataEditor", "storage.objectAdmin"]
  }
  "github-actions" = {
    account_id      = "github-actions"
    display_name    = "Github Actions Service Account"
    description     = "Service account for github actions"
    allow_iam_roles = true
    roles           = ["roles/artifactregistry.writer"]
  }
}

routers = {
  prd = {
    name    = "coral-network-router-prd"
    network = "https://www.googleapis.com/compute/v1/projects/coral-459111/global/networks/coral-network-prd"
  },
  stg = {
    name    = "coral-network-router"
    network = "https://www.googleapis.com/compute/v1/projects/coral-459111/global/networks/coral-network"
  }
}

kms_key_rings = {
  data_store_prd = {
    name       = "data-store-keyring-uat-prd"
    infix_name = "infix1"
    location   = "europe-west2"
    project_id = "coral-459111" #sji todo! this should be a var
    #service_account_key = "coral-flux-prd@coral-459111.iam.gserviceaccount.com"
    crypto_keys = {
      "data-store-key-uat-prd" = {
        name                = "data-store-key-uat-prd"
        service_account_key = "arches_uat_prd"
      }
      "flux-key-uat-prd" = {
        name                = "flux-key-uat-prd"
        service_account_key = "flux_prd"
      }
    }
    labels = {
      env = "prd"
      app = "data-store"
    }
  },
  data_store_uat = {
    name       = "data-store-keyring-uat"
    infix_name = "infix1"
    location   = "europe-west2"
    project_id = "coral-459111" #sji todo! this should be a var
    #service_account_key = "coral-arches-uat"
    crypto_keys = {
      "data-store-key-uat" = {
        name                = "data-store-key-uat"
        service_account_key = "arches_uat"
      }
    }
    labels = {
      env = "uat"
      app = "data-store"
    }
  }
}

clusters = {
  prd = {
    name               = "k8s-coral-prd"
    location           = "europe-west2-a"
    network            = "projects/coral-459111/global/networks/coral-network-prd"
    subnetwork         = "projects/coral-459111/regions/europe-west2/subnetworks/coral-subnetwork-prd"
    node_version       = "1.31.6-gke.1064001"
    min_master_version = "1.31.6-gke.1064001"
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
      service_account = "coral-arches-k8s-coral-prd@coral-459111.iam.gserviceaccount.com"
      shielded_instance_config = {
        enable_integrity_monitoring = true
      }
      workload_metadata_config = {
        mode = "GKE_METADATA"
      }
      labels = {
        TF_used_by  = "k8s-coral-prd"
        TF_used_for = "gke"
      }
      tags = ["gke-k8s-coral-prd-np-tf-cejctx"]
    }
    ip_allocation_policy = {
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
      # istio_config = {
      #   disabled = true
      #   auth     = "AUTH_MUTUAL_TLS"
      # } 
    }
    cluster_autoscaling = {
      autoscaling_profile = "BALANCED"
    }
    cluster_telemetry = {
      type = "ENABLED"
    }
    database_encryption = {
      state    = "DECRYPTED"
      key_name = ""
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
        end_time   = "2025-05-11T07:00:00Z"
        recurrence = "FREQ=WEEKLY;BYDAY=FR"
        start_time = "2025-05-10T19:00:00Z"
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
        enable_relay   = false
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
        audit_mode = "DISABLED"
      }
      # workload_vulnerability_mode = "WORKLOAD_VULNERABILITY_DISABLED"
    }
    release_channel = {
      channel = "REGULAR"
    }
    security_posture_config = {
      mode               = "BASIC"
      vulnerability_mode = "VULNERABILITY_DISABLED"
    }
    service_external_ips_config = {
      enabled = false
    }
    vertical_pod_autoscaling = {
      enabled = false
    }
    workload_identity_config = {
      workload_pool = "coral-459111.svc.id.goog"
    }
  },
  stg = {
    name               = "k8s-coral-stg"
    location           = "europe-west2-a"
    network            = "projects/coral-459111/global/networks/coral-network"
    subnetwork         = "projects/coral-459111/regions/europe-west2/subnetworks/coral-subnetwork"
    node_version       = "1.31.6-gke.1064001"
    min_master_version = "1.31.6-gke.1064001"
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
      service_account = "coral-arches-k8s-coral-stg@coral-459111.iam.gserviceaccount.com"
      shielded_instance_config = {
        enable_integrity_monitoring = true
      }
      labels = {
        TF_used_by  = "k8s-coral-stg"
        TF_used_for = "gke"
      }
      tags = ["gke-k8s-coral-stg-np-tf-cejctx"]
      workload_metadata_config = {
        mode = "GKE_METADATA"
      }
    }
    ip_allocation_policy = {
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
      # istio_config = {
      #   disabled = true
      #   auth     = "AUTH_MUTUAL_TLS"
      # }
    }
    cluster_autoscaling = {
      autoscaling_profile = "BALANCED"
    }
    cluster_telemetry = {
      type = "ENABLED"
    }
    database_encryption = {
      state    = "DECRYPTED"
      key_name = ""
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
        end_time   = "2025-05-11T23:00:00Z"
        recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
        start_time = "2025-05-11T19:00:00Z"
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
        enable_relay   = false
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
        audit_mode = "DISABLED"
      }
      # workload_vulnerability_mode = "WORKLOAD_VULNERABILITY_DISABLED"
    }
    release_channel = {
      channel = "REGULAR"
    }
    security_posture_config = {
      mode               = "BASIC"
      vulnerability_mode = "VULNERABILITY_DISABLED"
    }
    service_external_ips_config = {
      enabled = false
    }
    vertical_pod_autoscaling = {
      enabled = false
    }
    workload_identity_config = {
      workload_pool = "coral-459111.svc.id.goog"
    }
  }
}