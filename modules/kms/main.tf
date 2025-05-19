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
data "external" "key_ring_check" {
  program = ["${path.module}/scripts/check_key_ring.sh"]

  query = {
    project  = var.project_id
    location = var.location
    name     = var.name
  }
}

data "google_kms_key_ring" "existing" {
  count    = data.external.key_ring_check.result.exists ? 1 : 0
  name     = var.name
  project  = var.project_id
  location = var.location
}

locals {
  key_ring_id = data.external.key_ring_check.result.exists ? data.google_kms_key_ring.existing[0].id : google_kms_key_ring.key_ring[0].id
}

resource "google_kms_key_ring" "key_ring" {
  count    = data.external.key_ring_check.result.exists ? 0 : 1
  name     = var.name
  project  = var.project_id
  location = var.location
}

resource "google_kms_crypto_key" "crypto_key" {
  for_each        = var.crypto_keys
  name            = each.value.name
  key_ring        = local.key_ring_id #google_kms_key_ring.key_ring.id
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key_iam_member" "crypto_key_iam" {
  for_each = {
    for key, value in var.crypto_keys : key => value
    if value.service_account_key != ""
  }
  crypto_key_id = google_kms_crypto_key.crypto_key[each.key].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${var.service_accounts[each.value.service_account_key].account_id}@${var.project_id}.iam.gserviceaccount.com"
}