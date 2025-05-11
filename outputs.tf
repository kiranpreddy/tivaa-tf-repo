output "service_account_email" {
  description = "The email of the created service account."
  value       = google_service_account.tivaa_service_function_sa.email
}

output "service_account_name" {
  description = "The full name of the created service account."
  value       = google_service_account.tivaa_service_function_sa.name
}

output "cloud_run_service_url" {
  description = "The URL of the deployed Cloud Run service."
  value       = google_cloud_run_v2_service.tivaa_service.uri
}

output "cloud_run_service_name" {
  description = "The name of the deployed Cloud Run service."
  value       = google_cloud_run_v2_service.tivaa_service.name
}