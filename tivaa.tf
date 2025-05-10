resource "google_cloud_run_service" "rag_ai_app_service" {
  name     = var.service_name
  location = var.gcp_region
  project  = var.gcp_project_id

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all" # Allows traffic from all sources (internet), access controlled by IAM
    }
  }

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = var.max_instances
      }
    }

    spec {
      timeout_seconds      = var.service_timeout_seconds

      containers {
        image = var.docker_image_uri

        ports {
          container_port = var.app_port
        }

        resources {
          limits = {
            cpu    = var.service_cpu
            memory = var.service_memory
          }
        }

        dynamic "env" {
          for_each = var.environment_variables
          content {
            name  = env.value["name"]
            value = env.value["value"]
          }
        }
      }
    }
  }

    traffic {
      percent         = 100
      latest_revision = true
    }
  # Optional: depends_on other resources if needed, e.g., Artifact Registry repository or the SA
  depends_on = [
    google_service_account.rag_ai_function_sa, # If SA is in the same config
    google_project_iam_member.rag_ai_sa_vertex_ai_access # Ensure SA has permissions before service uses it
  ]
  }


# If public access is allowed
resource "google_cloud_run_service_iam_binding" "allow_public_for_rag_ai_app" {
  count    = var.allow_public_access ? 1 : 0
  project  = google_cloud_run_service.rag_ai_app_service.project
  location = google_cloud_run_service.rag_ai_app_service.location
  service  = google_cloud_run_service.rag_ai_app_service.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}

# If public access is NOT allowed, grant invoker role to specified principals
resource "google_cloud_run_service_iam_member" "rag_ai_app_invokers" {
  count    = !var.allow_public_access && length(var.invoker_principals) > 0 ? length(var.invoker_principals) : 0
  project  = google_cloud_run_service.rag_ai_app_service.project
  location = google_cloud_run_service.rag_ai_app_service.location
  service  = google_cloud_run_service.rag_ai_app_service.name
  role     = "roles/run.invoker"
  member   = var.invoker_principals[count.index]
}

resource "google_cloud_run_service_iam_policy" "no_auth" {
  location    = google_cloud_run_service.rag_ai_app_service.location
  service     = google_cloud_run_service.rag_ai_app_service.name

  policy_data = data.google_iam_policy.no_auth_policy.policy_data
}

data "google_iam_policy" "no_auth_policy" {
  binding {
    role = "roles/run.invoker"

    members = [
      "allUsers",
    ]
  }
}