resource "google_service_account" "service_account" {
  for_each     = var.service_accounts
  project      = var.project_id
  account_id   = each.value.account_id
  display_name = each.value.display_name
  description  = each.value.description
}

resource "google_project_iam_binding" "service_account_roles" {
  for_each = toset(flatten([for sa in var.service_accounts : sa.roles]))
  project  = var.project_id
  role     = "roles/${each.value}"
  members  = [
    for sa_key, sa in var.service_accounts :
    "serviceAccount:${google_service_account.service_account[sa_key].email}"
    if contains(sa.roles, each.value)
  ]
}