output "key_ring_name" {
  description = "The name of the created KMS Key Ring"
  value       = google_kms_key_ring.key_ring.name
}