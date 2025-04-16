output "flux_sa" {
  value       = module.service_accounts.flux_sa_email
  description = "Email address of the Flux service account"
}