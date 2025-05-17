


# Enable necessary APIs for the RAG AI Application
resource "google_project_service" "tiiva_service_artifactregistry" {
  project                    = var.gcp_project_id
  service                    = "artifactregistry.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_cloudfunctions" {
  project                    = var.gcp_project_id
  service                    = "cloudfunctions.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_cloudrun" {
  project                    = var.gcp_project_id
  service                    = "run.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_storage" {
  project                    = var.gcp_project_id
  service                    = "storage.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_vertex_ai" {
  project                    = var.gcp_project_id
  service                    = "aiplatform.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_iam" {
  project                    = var.gcp_project_id
  service                    = "iam.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_logging" {
  project                    = var.gcp_project_id
  service                    = "logging.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_monitoring" {
  project                    = var.gcp_project_id
  service                    = "monitoring.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_secretmanager" {
  project                    = var.gcp_project_id
  service                    = "secretmanager.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}


resource "google_project_service" "tiiva_service_cloudbuild" {
  project                    = var.gcp_project_id
  service                    = "cloudbuild.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_servicenetworking" {
  project                    = var.gcp_project_id
  service                    = "servicenetworking.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_compute" {
  project                    = var.gcp_project_id
  service                    = "compute.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_vpcaccess" {
  project                    = var.gcp_project_id
  service                    = "vpcaccess.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tiiva_service_documentai" {
  project                    = var.gcp_project_id
  service                    = "documentai.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}




# Wait for APIs to become ready
resource "time_sleep" "wait_x_minutes" {
  depends_on = [
    google_project_service.tiiva_service_artifactregistry,
    google_project_service.tiiva_service_secretmanager,
    google_project_service.tiiva_service_compute,
    google_project_service.tiiva_service_cloudfunctions,
    google_project_service.tiiva_service_cloudrun,
    google_project_service.tiiva_service_storage,
    google_project_service.tiiva_service_vertex_ai,
    google_project_service.tiiva_service_iam,
    google_project_service.tiiva_service_logging,
    google_project_service.tiiva_service_monitoring,
    google_project_service.tiiva_service_documentai,
    google_project_service.tiiva_service_cloudbuild,
    google_project_service.tiiva_service_servicenetworking,
    google_project_service.tiiva_service_vpcaccess,
  ]
  create_duration = "360s"
}
