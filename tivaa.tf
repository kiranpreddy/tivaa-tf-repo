resource "google_cloud_run_v2_service" "tivaa_service" {
  name     = "${var.tenant_name}-tivaa-service"
  location = var.gcp_region
  project  = var.gcp_project_id
  deletion_protection = false
  ingress  = "INGRESS_TRAFFIC_ALL" # Allow traffic from all sources (internal and external)

  template {
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
          name  = env.key
          value = env.value
        }
      }
    }

    # Attach the service account
    service_account = google_service_account.tivaa_service_function_sa.email

    vpc_access {
      connector = google_vpc_access_connector.tivaa_service_private_connector.id
      egress    = "ALL_TRAFFIC" # Or "PRIVATE_RANGES_ONLY"
    }

    scaling {
      max_instance_count = var.max_instances
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  depends_on = [
    google_service_account.tivaa_service_function_sa,
    google_project_iam_member.tivaa_service_sa_vertex_ai_access,
    google_vpc_access_connector.tivaa_service_private_connector # Ensure VPC connector is created first
  ]
}

# If public access is allowed
resource "google_cloud_run_v2_service_iam_binding" "allow_public_for_tivaa_service" {
  count    = var.allow_public_access ? 1 : 0
  project  = google_cloud_run_v2_service.tivaa_service.project
  location = google_cloud_run_v2_service.tivaa_service.location
  name     = google_cloud_run_v2_service.tivaa_service.name
  role     = "roles/run.invoker"
  members  = ["allUsers"] # Allow public access
}

# If public access is NOT allowed, grant invoker role to specified principals
resource "google_cloud_run_v2_service_iam_member" "tivaa_service_invokers" {
  count    = !var.allow_public_access && length(var.invoker_principals) > 0 ? length(var.invoker_principals) : 0
  project  = google_cloud_run_v2_service.tivaa_service.project
  location = google_cloud_run_v2_service.tivaa_service.location
  name     = google_cloud_run_v2_service.tivaa_service.name # Changed from 'service' to 'name'
  role     = "roles/run.invoker"
  member   = var.invoker_principals[count.index]
}

