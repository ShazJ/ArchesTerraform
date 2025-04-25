# environments/dev/main.tf
module "network" {
  source      = "../../modules/network"
  project_id  = var.project_id
  environment = var.environment
  region      = var.region
  subnet_cidr = "10.0.1.0/24"
}

module "storage" {
  source      = "../../modules/storage"
  project_id  = var.project_id
  environment = var.environment
  region      = var.region
}

module "service_accounts" {
  source             = "../../modules/service_accounts"
  project_id         = var.project_id
  environment        = var.environment
  tenant_data_bucket = module.storage.tenant_data_bucket
}

module "compute" {
  source        = "../../modules/compute"
  project_id    = var.project_id
  environment   = var.environment
  region        = var.region
  subnet_id     = module.network.subnet_id
  vm_sa_email   = module.service_accounts.vm_sa_email
  machine_type  = "e2-standard-2"
}