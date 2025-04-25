# terraform {
#   backend "gcs" {
#     bucket = "my-terraform-state"
#     prefix = "dev"
#   }
# } need this? hmmmm sji or just refix everything with dev....

module "network" {
  source       = "../../modules/network"
  network_name = "dev-network"
  subnet_cidr  = "10.0.0.0/24"
  region       = var.region
}
module "network" {
  source       = "../../modules/network"
  project_id   = var.project_id
  environment  = "dev"
  vpc_name     = "dev-vpc"
  subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
}


module "storage" {
  source      = "../../modules/storage"
  bucket_name = "dev-storage-${var.project_id}"
  location    = var.region
}
module "storage" {
  source      = "../../modules/storage"
  project_id  = var.project_id
  environment = "dev"
  bucket_name = "dev-bucket"
}

module "service_account" {
  source             = "../../modules/service_account"
  service_account_id = "dev-sa"
  display_name       = "Dev Service Account"
}

module "service_account" {
  source             = "../../modules/service_account"
  service_account_id = "dev-sa"
  display_name       = "Dev Service Account"
}
module "service_account" {
  source      = "../../modules/service_account"
  project_id  = var.project_id
  environment = "dev"
  sa_name     = "dev-sa"
}

module "vm" {
  source         = "../../modules/vm"
  instance_name  = "dev-vm"
  machine_type   = "e2-medium"
  zone           = var.zone
  network        = module.network.network_self_link
  subnetwork     = "${module.network.network_self_link}-subnet"
}

module "compute" {
  source            = "../../modules/compute"
  project_id        = var.project_id
  environment       = "dev"
  subnet_self_link  = module.network.subnet_self_links[0]
  service_account   = module.service_account.email
}

