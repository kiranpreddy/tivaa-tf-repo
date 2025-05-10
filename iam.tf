resource "google_service_account" "rag_ai_function_sa" {
  project      = var.gcp_project_id
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  description  = "Service account for the RAG AI Cloud Function to access GCP services."
}

# For Vertex AI (project-level)
resource "google_project_iam_member" "rag_ai_sa_vertex_ai_access" {
  project = var.gcp_project_id
  role    = var.vertex_ai_role
  member  = "serviceAccount:${google_service_account.rag_ai_function_sa.email}"
}

# For Cloud Storage (bucket-level)
# This assumes the bucket already exists or is managed elsewhere in your Terraform config.
# If the bucket is created in the same Terraform configuration, you can use its ID directly.
resource "google_storage_bucket_iam_member" "rag_ai_sa_storage_bucket_access" {
  bucket = google_storage_bucket.tivaa_ai_function_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.rag_ai_function_sa.email}"

  depends_on = [google_storage_bucket.tivaa_ai_function_bucket]
}

# (Optional) For Secret Manager (project-level)
resource "google_project_iam_member" "rag_ai_sa_secret_manager_access" {
  count   = var.enable_secret_manager_access ? 1 : 0 # Only create this binding if enable_secret_manager_access is true
  project = var.gcp_project_id
  role    = var.secret_manager_role
  member  = "serviceAccount:${google_service_account.rag_ai_function_sa.email}"
}

resource "google_storage_bucket" "tivaa_ai_function_bucket" {
  name     = var.cloud_storage_bucket_name
  location = var.gcp_region
}
