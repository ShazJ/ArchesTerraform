resource "google_service_account" "coral_arches_k8s_coral_prd" {
  account_id   = "coral-arches-k8s-coral-prd"
  description  = "Its IAM role(s) will specify the access-levels that the GKE node(s) may have"
  display_name = "coral-arches-k8s coral-prd"
  project      = "coral-370212"
}
# terraform import google_service_account.coral_arches_k8s_coral_prd projects/coral-370212/serviceAccounts/coral-arches-k8s-coral-prd@coral-370212.iam.gserviceaccount.com
