output "enabled_services_list" {
   description = "List of enabled services."
   value = [
     google_project_service.artifactregistry.service,
     google_project_service.cloudfunctions.service,
     google_project_service.cloudrun.service,
     google_project_service.storage.service,
     google_project_service.vertex_ai.service,
     google_project_service.iam.service,
     google_project_service.logging.service,
     google_project_service.monitoring.service,
     google_project_service.secretmanager.service,
   ]
 }

output "service_account_email" {
  description = "The email of the created service account."
  value       = google_service_account.rag_ai_function_sa.email
}

output "service_account_name" {
  description = "The full name of the created service account."
  value       = google_service_account.rag_ai_function_sa.name
}


#output "cloud_run_service_url" {
#  description = "The URL of the deployed Cloud Run service."
#  value       = google_cloud_run_v2_service.rag_ai_app_service.uri
#}

#output "cloud_run_service_name" {
#  description = "The name of the deployed Cloud Run service."
#  value       = google_cloud_run_v2_service.rag_ai_app_service.name
#}