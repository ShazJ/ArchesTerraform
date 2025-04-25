# modules/service_accounts/main.tf
resource "google_service_account" "vm" {
  project      = var.project_id
  account_id   = "${var.project_id}-vm-sa-${var.environment}"
  display_name = "VM Service Account (${var.environment})"
}

resource "google_service_account" "k8s" { #"coral-arches-k8s-coral-prd"  "Its IAM role(s) will specify the access-levels that the GKE node(s) may have"
  account_id   = "${var.project_id}-k8s-sa-${var.environment}"
  display_name = "Kubernetes Service Account (${var.environment})"
}

resource "google_service_account" "storage" {
  account_id   = "${var.project_id}-storage-sa-${var.environment}"
  display_name = "Storage Service Account (${var.environment})"
}

coral_arches_uat_prd
coral_ci_prd "Coral Production Arches Service Account"
coral_gl_ci_prd  "Coral Production Data Operations Service Account"
coral_flux_prd  "Coral Production Flux Service Account"
707500278544_compute

# IAM bindings for least privilege
resource "google_project_iam_member" "vm_compute" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.vm.email}"
}

resource "google_project_iam_member" "k8s_container" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.k8s.email}"
}

resource "google_storage_bucket_iam_member" "storage_access" {
  bucket = var.tenant_data_bucket
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.storage.email}"
}