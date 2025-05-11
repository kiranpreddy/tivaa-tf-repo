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

output "document_processor_id" {
  description = "The ID of the Document AI processor"
  value       = google_document_ai_processor.tivaa_document_processor.id
}

output "tivaa_bucket_name" {
  description = "The name of the TIVAA Bucket"
  value       = google_storage_bucket.tivaa_service_function_bucket.name
}