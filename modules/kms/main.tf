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
# NOTE! GCP does not allow the deletion of a key ring AT ALL
# and the key ring name must be unique within the project and location.
# So, if you want to delete a key ring, you must delete the project.
# Hence, we have added checking to see if the key ring already exists
# and if it does, we will not create a new one.
# This is a workaround to avoid the error of trying to create a key ring
# that already exists.

# Check if the key ring already exists
data "google_kms_key_ring" "existing" {
  project  = var.project_id
  name     = var.name
  location = var.location
}

# Create the key ring only if it doesn't exist
resource "google_kms_key_ring" "key_ring" {
  count    = try(data.google_kms_key_ring.existing.id, "") == "" ? 1 : 0
  project  = var.project_id
  name     = var.name
  location = var.location
}

# Reference the key ring ID (existing or new)
locals {
  key_ring_id = try(data.google_kms_key_ring.existing.id, google_kms_key_ring.key_ring[0].id)
}

resource "google_kms_crypto_key" "crypto_key" {
  for_each        = var.crypto_keys
  key_ring        = local.key_ring_id #google_kms_key_ring.key_ring.id
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