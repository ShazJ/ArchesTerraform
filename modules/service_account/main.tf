resource "google_service_account" "service_account" {
  for_each     = var.service_accounts
  project      = var.project_id
  account_id   = each.value.account_id
  display_name = each.value.display_name
  description  = each.value.description
}

resource "google_project_iam_member" "service_account_roles" {
  for_each = {
    for entry in flatten([
      for sa_key, sa in var.service_accounts : [
        for role in sa.roles : {
          sa_key = sa_key
          role   = role
        }
      ]
    ]) : "${entry.sa_key}.${entry.role}" => entry
    if length(var.service_accounts[entry.sa_key].roles) > 0
  }
  project = var.project_id
  role    = "roles/${each.value.role}"
  member  = "serviceAccount:${google_service_account.service_account[each.value.sa_key].email}"
}