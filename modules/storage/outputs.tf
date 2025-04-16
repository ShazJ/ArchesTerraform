# modules/storage/outputs.tf
output "tenant_data_bucket" {
  value = google_storage_bucket.tenant_data.name
}

output "logs_bucket" {
  value = google_storage_bucket.logs.name
}