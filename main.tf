provider "google" {
  project = var.gcp_project_id # Replace with your GCP project ID
  region  = var.gcp_region     # Replace with your desired region
}

# Enable necessary APIs for the RAG AI Application
resource "google_project_service" "tivaa_service_artifactregistry" {
  project                    = var.gcp_project_id
  service                    = "artifactregistry.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_cloudfunctions" {
  project                    = var.gcp_project_id
  service                    = "cloudfunctions.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_cloudrun" {
  project                    = var.gcp_project_id
  service                    = "run.googleapis.com" # Cloud Run API (for Cloud Functions 2nd Gen)
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_storage" {
  project                    = var.gcp_project_id
  service                    = "storage.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_vertex_ai" {
  project                    = var.gcp_project_id
  service                    = "aiplatform.googleapis.com" # Vertex AI API
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_iam" {
  project                    = var.gcp_project_id
  service                    = "iam.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_logging" {
  project                    = var.gcp_project_id
  service                    = "logging.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_monitoring" {
  project                    = var.gcp_project_id
  service                    = "monitoring.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_secretmanager" {
  project                    = var.gcp_project_id
  service                    = "secretmanager.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_documentai" {
  project                    = var.gcp_project_id
  service                    = "documentai.googleapis.com" # Document AI API
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_cloudbuild" {
  project                    = var.gcp_project_id
  service                    = "cloudbuild.googleapis.com" # Cloud Build API
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_servicenetworking" {
  project                    = var.gcp_project_id
  service                    = "servicenetworking.googleapis.com" # Service Networking API
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_compute" {
  project                    = var.gcp_project_id
  service                    = "compute.googleapis.com" # Compute Engine API
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "tivaa_service_vpcaccess" {
  project                    = var.gcp_project_id
  service                    = "vpcaccess.googleapis.com" # Serverless VPC Access API
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Introduce a delay after creating these resources, since it may take some time for the APIs to be fully enabled and ready for use. 
# This is especially important for services like Cloud Functions and Cloud Run, which may require some time to initialize.
# The time_sleep resource is used to create a delay in the Terraform execution plan.
resource "time_sleep" "wait_6_minutes" {
  depends_on = [
    google_project_service.tivaa_service_artifactregistry,
    google_project_service.tivaa_service_cloudfunctions,
    google_project_service.tivaa_service_cloudrun,
    google_project_service.tivaa_service_storage,
    google_project_service.tivaa_service_vertex_ai,
    google_project_service.tivaa_service_iam,
    google_project_service.tivaa_service_logging,
    google_project_service.tivaa_service_monitoring,
    google_project_service.tivaa_service_secretmanager,
    google_project_service.tivaa_service_documentai,
    google_project_service.tivaa_service_cloudbuild,
    google_project_service.tivaa_service_servicenetworking,
    google_project_service.tivaa_service_compute,
    google_project_service.tivaa_service_vpcaccess
  ]
  create_duration = "360s" # Wait for 5 minute
}
