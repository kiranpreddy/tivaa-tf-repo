resource "google_service_account_key" "tiiva_service_key" {
  service_account_id = google_service_account.tiiva_service_function_sa.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

resource "google_secret_manager_secret" "tiiva_sa_secret" {
  secret_id = "${var.tenant_name}-sa-key"
  replication {
    user_managed {
      replicas { location = var.gcp_region }
    }
  }
}

resource "google_secret_manager_secret_version" "tiiva_sa_secret_version" {
  secret      = google_secret_manager_secret.tiiva_sa_secret.id
  secret_data = google_service_account_key.tiiva_service_key.private_key
}

resource "google_secret_manager_secret_iam_member" "tiiva_sa_secret_accessor" {
  secret_id = google_secret_manager_secret.tiiva_sa_secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.tiiva_service_function_sa.email}"
}



resource "google_service_account" "tiiva_service_function_sa" {
  project      = var.gcp_project_id
  account_id   = var.service_account_id
  display_name = "${var.tenant_name}-service-account"
  description  = "Service account for the RAG AI Cloud Function to access GCP services."
}

# For Vertex AI (project-level)
resource "google_project_iam_member" "tiiva_service_sa_vertex_ai_access" {
  project = var.gcp_project_id
  role    = var.vertex_ai_role
  member  = "serviceAccount:${google_service_account.tiiva_service_function_sa.email}"
}

resource "google_project_iam_member" "tiiva_service_sa_secret_manager_access" {
  count   = var.enable_secret_manager_access ? 1 : 0
  project = var.gcp_project_id
  role    = var.secret_manager_role
  member  = "serviceAccount:${google_service_account.tiiva_service_function_sa.email}"
}

resource "google_storage_bucket" "tiiva_service_function_bucket" {
  name     = "${var.tenant_name}-storage-bucket"
  location = var.gcp_region

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 1
    }
  }
}

resource "google_project_iam_audit_config" "storage_data_write" {
  project = var.gcp_project_id
  service = "storage.googleapis.com"

  audit_log_config {
    log_type = "DATA_WRITE"
  }
}



resource "google_storage_bucket_iam_member" "tiiva_service_sa_storage_bucket_access" {
  bucket = google_storage_bucket.tiiva_service_function_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.tiiva_service_function_sa.email}"

  depends_on = [google_storage_bucket.tiiva_service_function_bucket]
}




resource "google_document_ai_processor" "tivaa_document_processor" {
  provider     = google-beta
  project      = var.gcp_project_id
  location     = var.ocai_location
  display_name = "${var.tenant_name}-processor"
  type         = "OCR_PROCESSOR"

  depends_on = [
    google_project_service.tiiva_service_documentai
  ]
}

resource "google_project_iam_member" "tiiva_docai_api_user" {
  project = var.gcp_project_id
  role    = "roles/documentai.apiUser"
  member  = "serviceAccount:${google_service_account.tiiva_service_function_sa.email}"

  depends_on = [
    google_project_service.tiiva_service_documentai,
  ]
}


resource "google_project_iam_member" "tiiva_service_sa_logs_writer" {
  project = var.gcp_project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.tiiva_service_function_sa.email}"

  depends_on = [
    google_project_service.tiiva_service_logging
  ]
}
