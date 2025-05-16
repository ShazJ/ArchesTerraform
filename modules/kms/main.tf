# resource "google_kms_key_ring" "keyring" {
#   name     = "${var.keyring_name}${var.infix_name}"
#   location = var.region
#   project = var.project_id

# }

# resource "google_kms_crypto_key" "keys" {
#   for_each = { for key in var.crypto_keys : "${key.name}${var.infix_name}" => key }

#   name            = each.key
#   key_ring        = google_kms_key_ring.keyring.id
#   rotation_period = each.value.rotation_period

#   version_template {
#     algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
#     protection_level = "SOFTWARE"
#   }
#   # lifecycle {
#   #   prevent_destroy = false #true sji todo not in prod but should be?
#   # }
# }

# resource "google_kms_crypto_key_iam_binding" "kms_key_iam" {
#   for_each = { for binding in var.iam_bindings : "${binding.crypto_key_id}-${binding.role}" => binding }

#   crypto_key_id = each.value.crypto_key_id
#   role          = each.value.role
#   members       = each.value.members
# } 

resource "google_kms_key_ring" "key_ring" {
  project  = var.project_id
  name     = var.name
  location = var.location
}

resource "google_kms_crypto_key" "crypto_key" {
  for_each        = var.crypto_keys
  key_ring        = google_kms_key_ring.key_ring.id
  name            = each.value.name
  labels          = var.labels
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = "7776000s" # 90 days
}

resource "google_kms_crypto_key_iam_binding" "crypto_key_binding" {
  for_each      = var.crypto_keys
  crypto_key_id = google_kms_crypto_key.crypto_key[each.key].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    "serviceAccount:${each.value.service_account_key}@${var.project_id}.iam.gserviceaccount.com"
  ]
}