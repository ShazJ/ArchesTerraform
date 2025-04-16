resource "google_service_account" "coral_ci_prd" {
  account_id   = "coral-ci-prd"
  display_name = "Coral Production Arches Service Account"
  project      = "coral-370212"
}
# terraform import google_service_account.coral_ci_prd projects/coral-370212/serviceAccounts/coral-ci-prd@coral-370212.iam.gserviceaccount.com
