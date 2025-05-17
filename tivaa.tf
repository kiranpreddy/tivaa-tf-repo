locals {

  service_id = "${var.app_prefix}-${var.app_name}-${var.app_env}"


  static_env = {
    ENCOMPASS_AUTH_URL    = "https://api.elliemae.com/oauth2/v1/token"
    ENCOMPASS_BASE_URL    = "https://api.elliemae.com/encompass/v3/loans"
    GCS_CONST_FOLDER      = "selling-guide"
    DOCAI_LOCATION        = "us"
    PIPELINE_REPORT_URL   = "https://api.elliemae.com/encompass/v3/loanPipeline/report"
    GCS_FOLDER            = "condos"
    QUESTIONNAIRE_PREFIX  = "questionnaire/liberty"
    DOCAI_PROCESSOR_ID    = regex("^.*/([^/]+)$", google_document_ai_processor.tivaa_document_processor.id)[0]
    GOOGLE_CLOUD_PROJECT  = var.gcp_project_id
    GCS_BUCKET_NAME       = google_storage_bucket.tiiva_service_function_bucket.name
    SECRET_KEY            = google_secret_manager_secret.tiiva_sa_secret
    REDEPLOY_TS           = timestamp()
  }

  all_env = merge(
    local.static_env,
    var.environment_variables
  )
}

resource "google_cloud_run_v2_service" "tiiva_service" {
  name     = local.service_id
  project  = var.gcp_project_id
  location = var.gcp_region
  deletion_protection = false
  ingress  = "INGRESS_TRAFFIC_ALL"

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
        for_each = local.all_env
        content {
          name  = env.key
          value = env.value
        }
      }
    }

    service_account = google_service_account.tiiva_service_function_sa.email

    vpc_access {
      connector = google_vpc_access_connector.tiiva_service_private_connector.id
      egress    = "ALL_TRAFFIC"
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
    google_document_ai_processor.tivaa_document_processor,
    google_service_account.tiiva_service_function_sa,
    google_project_iam_member.tiiva_docai_api_user,
    google_vpc_access_connector.tiiva_service_private_connector,
  ]
}

resource "google_cloud_run_v2_service_iam_binding" "allow_public_for_tiiva_service" {
  count    = var.allow_public_access ? 1 : 0
  project  = google_cloud_run_v2_service.tiiva_service.project
  location = google_cloud_run_v2_service.tiiva_service.location
  name     = google_cloud_run_v2_service.tiiva_service.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}

resource "google_cloud_run_v2_service_iam_member" "tiiva_service_invokers" {
  count    = !var.allow_public_access && length(var.invoker_principals) > 0 ? length(var.invoker_principals) : 0
  project  = google_cloud_run_v2_service.tiiva_service.project
  location = google_cloud_run_v2_service.tiiva_service.location
  name     = google_cloud_run_v2_service.tiiva_service.name
  role     = "roles/run.invoker"
  member   = var.invoker_principals[count.index]
}
