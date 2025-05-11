resource "google_service_account" "tivaa_service_function_sa" {
  project      = var.gcp_project_id
  account_id   = var.service_account_id
  display_name = "${var.tenant_name}-service-account"
  description  = "Service account for the RAG AI Cloud Function to access GCP services."
}

# For Vertex AI (project-level)
resource "google_project_iam_member" "tivaa_service_sa_vertex_ai_access" {
  project = var.gcp_project_id
  role    = var.vertex_ai_role
  member  = "serviceAccount:${google_service_account.tivaa_service_function_sa.email}"
}

# (Optional) For Secret Manager (project-level)
resource "google_project_iam_member" "tivaa_service_sa_secret_manager_access" {
  count   = var.enable_secret_manager_access ? 1 : 0 # Only create this binding if enable_secret_manager_access is true
  project = var.gcp_project_id
  role    = var.secret_manager_role
  member  = "serviceAccount:${google_service_account.tivaa_service_function_sa.email}"
}

resource "google_storage_bucket" "tivaa_service_function_bucket" {
  name     = "${var.tenant_name}-storage-bucket"
  location = var.gcp_region

  # Enable uniform bucket-level access
  uniform_bucket_level_access = true

  # Prevent public access
  public_access_prevention = "enforced"
}

# For Cloud Storage (bucket-level)
resource "google_storage_bucket_iam_member" "tivaa_service_sa_storage_bucket_access" {
  bucket = google_storage_bucket.tivaa_service_function_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.tivaa_service_function_sa.email}"

  depends_on = [google_storage_bucket.tivaa_service_function_bucket]
}
