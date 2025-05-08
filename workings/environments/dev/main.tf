module "service_account" {
  source      = "../../modules/service_account"
  environment = var.environment
  project_id  = var.project_id
}

module "storage" {
  source      = "../../modules/storage"
  environment = var.environment
  project_id  = var.project_id
  region      = var.region
}

module "network" {
  source        = "../../modules/network"
  environment   = var.environment
  region        = var.region
  subnet_cidr   = "10.0.1.0/24"
  project_id    = var.project_id
}

module "kubernetes" {
  source               = "../../modules/kubernetes"
  environment          = var.environment
  region               = var.region
  subnet_id            = module.network.subnet_id
  machine_type         = "e2-standard-2"
  service_account_email = module.service_account.service_account_email
  project_id           = var.project_id
}