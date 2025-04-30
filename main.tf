locals {
  env_configs = {
    dev = {
      subnet_cidr  = "10.0.1.0/24"
      machine_type = "e2-standard-2"
    }
    uat = {
      subnet_cidr  = "10.0.2.0/24"
      machine_type = "e2-standard-4"
    }
    prod = {
      subnet_cidr  = "10.0.3.0/24"
      machine_type = "e2-standard-8"
    }
  }

  selected_env = lookup(local.env_configs, var.environment, local.env_configs["dev"])
}

module "service_account" {
  source      = "./modules/service_account"
  environment = var.environment
  project_id  = var.project_id
}

module "storage" {
  source      = "./modules/storage"
  environment = var.environment
  project_id  = var.project_id
  region      = var.region
}

module "network" {
  source      = "./modules/network"
  environment = var.environment
  region      = var.region
  subnet_cidr = local.selected_env.subnet_cidr
  project_id  = var.project_id
}

module "kubernetes" {
  source                = "./modules/kubernetes"
  environment           = var.environment
  region                = var.region
  subnet_id             = module.network.subnet_id
  machine_type          = local.selected_env.machine_type
  service_account_email = module.service_account.service_account_email
  project_id            = var.project_id
}
