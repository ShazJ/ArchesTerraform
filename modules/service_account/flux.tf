resource "google_service_account" "coral_flux_prd" {
  account_id   = "coral-flux-prd"
  display_name = "Coral Production Flux Service Account"
  project      = "coral-370212"
}
# terraform import google_service_account.coral_flux_prd projects/coral-370212/serviceAccounts/coral-flux-prd@coral-370212.iam.gserviceaccount.com
