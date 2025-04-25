output "tenant_data_bucket" {
  value = google_storage_bucket.tenant_data.name
}

output "logs_bucket" {
  value = google_storage_bucket.logs.name
}

#remove the followin, just for interest sji
output "tenant_bucket_url" {
  value = google_storage_bucket.tenant_data.url
}

output "logs_bucket_url" {
  value = google_storage_bucket.logs_data.url
}