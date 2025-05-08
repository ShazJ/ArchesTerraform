# modules/service_accounts/outputs.tf
output "vm_sa_email" {
  value = google_service_account.vm.email
}

output "k8s_sa_email" {
  value = google_service_account.k8s.email
}

output "storage_sa_email" {
  value = google_service_account.storage.email
}