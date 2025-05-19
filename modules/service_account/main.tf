resource "google_service_account" "service_account" {
  for_each     = var.service_accounts
  project      = var.project_id
  account_id   = each.value.account_id
  display_name = each.value.display_name
  description  = each.value.description
}

resource "google_project_iam_member" "service_account_roles" {
  for_each = { for role_assignment in flatten([
    for sa_key, roles in var.service_account_roles : [
      for role in roles : {
        sa_key = sa_key
        role   = role
      }
    ]
  ]) : "${role_assignment.sa_key}.${role_assignment.role}" => role_assignment }

  project = var.project_id
  role    = "roles/${each.value.role}"
  member  = "serviceAccount:${var.service_accounts[each.value.sa_key].account_id}@${var.project_id}.iam.gserviceaccount.com"
}