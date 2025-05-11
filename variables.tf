variable "gcp_project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "The GCP region"
  type        = string
}

variable "service_account_id" {
  description = "The desired ID for the new service account (e.g., 'rag-ai-function-sa')."
  type        = string
  default     = "tivaa-ai-function-sa"
}

variable "vertex_ai_role" {
  description = "The IAM role to grant for Vertex AI access."
  type        = string
  default     = "roles/aiplatform.user" # Common role, adjust if more permissions are needed
}

variable "storage_bucket_role" {
  description = "The IAM role to grant for Cloud Storage bucket access."
  type        = string
  default     = "roles/storage.objectAdmin" # Allows managing objects in the bucket. Use roles/storage.objectUser for read/write without delete.
}

variable "secret_manager_role" {
  description = "The IAM role to grant for Secret Manager access (if used)."
  type        = string
  default     = "roles/secretmanager.secretAccessor"
}

variable "enable_secret_manager_access" {
  description = "Set to true to grant Secret Manager access to the service account."
  type        = bool
  default     = true # Set to false if your application doesn't use Secret Manager
}

variable "function_description" {
  description = "Description for the deployed service/function."
  type        = string
  default     = "RAG AI Application with UI"
}

variable "docker_image_uri" {
  description = "The full URI of your Docker image in Artifact Registry (e.g., 'us-central1-docker.pkg.dev/your-project/your-repo/your-image:tag')."
  type        = string
  # Example: "us-central1-docker.pkg.dev/my-gcp-project/my-docker-repo/rag-app:latest"
}

variable "service_account_email" {
  description = "The email of the service account to be used by the Cloud Run service. This should be the output from your Phase 4 Terraform."
  type        = string
}

variable "environment_variables" {
  description = "Environment variables (e.g. BUCKET_NAME, VERTEX_AI_PROJECT)"
  type        = map(string)
  default = {
  }
}

variable "app_port" {
  description = "The port your application inside the Docker container listens on. Cloud Run will send requests to this port."
  type        = number
  default     = 8080 # Common default, adjust if your app uses a different port
}

variable "service_memory" {
  description = "Memory allocated to the Cloud Run service (e.g., '512Mi', '1Gi')."
  type        = string
  default     = "4096Mi"
}

variable "service_cpu" {
  description = "CPU allocated to the Cloud Run service (e.g., '1', '2', '0.5'). String value."
  type        = string
  default     = "1" # Corresponds to 1 vCPU
}

variable "service_timeout_seconds" {
  description = "Request timeout for the Cloud Run service in seconds."
  type        = number
  default     = 300 # 5 minutes
}

variable "max_instances" {
  description = "Maximum number of container instances for the service. Set to 0 for default scaling."
  type        = number
  default     = 3 # Adjust based on expected load
}

# --- Phase 6: Security Variables ---
variable "allow_public_access" {
  description = "If true, the service will be publicly accessible. If false, IAM permissions are required for invocation."
  type        = bool
  default     = false # Secure by default
}

variable "invoker_principals" {
  description = "A list of IAM principals (e.g., 'user:name@example.com', 'serviceAccount:...') that can invoke the service if allow_public_access is false."
  type        = list(string)
  default     = []
  # Example: ["user:jane.doe@example.com", "serviceAccount:my-other-sa@my-gcp-project-id.iam.gserviceaccount.com"]
}

variable "tenant_name" {
  description = "The name of the tenant, Be between 1 and 23 characters long"
  type        = string
}

variable "tenant_authorized_ip_cidr" {
  description = "The IP or CIDR range allowed to access the Cloud Run service"
  type        = string
  default     = "35.23.45.67/32" # Replace with your desired IP or CIDR range
}

variable "artifact_registry_project_id" {
  description = "The project ID where the Artifact Registry resides"
  type        = string
  default     = "united-park-449017-e8"
}

variable "ocai_location" {
  description = "The project ID where the Artifact Registry resides"
  type        = string
  default     = "us"
}