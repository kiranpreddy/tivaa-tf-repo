provider "google" {
  project = var.gcp_project_id # Replace with your GCP project ID
  region  = var.gcp_region         # Replace with your desired region
}

# Enable necessary APIs for the RAG AI Application
resource "google_project_service" "artifactregistry" {
  project                    = var.gcp_project_id
  service                    = "artifactregistry.googleapis.com"
  disable_dependent_services = false # Set to true if you want to disable services that depend on this one when this is destroyed
  disable_on_destroy         = false # Set to false if you want the API to remain enabled even after the resource is destroyed from Terraform state
}

resource "google_project_service" "cloudfunctions" {
  project                    = var.gcp_project_id
  service                    = "cloudfunctions.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "cloudrun" {
  project                    = var.gcp_project_id
  service                    = "run.googleapis.com" # Cloud Run API (for Cloud Functions 2nd Gen)
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "storage" {
  project                    = var.gcp_project_id
  service                    = "storage.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "vertex_ai" {
  project                    = var.gcp_project_id
  service                    = "aiplatform.googleapis.com" # Vertex AI API
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "iam" {
  project                    = var.gcp_project_id
  service                    = "iam.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "logging" {
  project                    = var.gcp_project_id
  service                    = "logging.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "monitoring" {
  project                    = var.gcp_project_id
  service                    = "monitoring.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "secretmanager" {
  project                    = var.gcp_project_id
  service                    = "secretmanager.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}
