# Provide values for variables defined in variables.tf
gcp_project_id = "tenant1-459420"
tenant_name = "techniecode-qa"
gcp_region = "us-central1"
docker_image_uri="gcr.io/united-park-449017-e8/techniecode-aicondoreviewapi:latest"
service_account_email="harsha.test7@techniecode.com"
allow_public_access = true
environment_variables = {
    GCS_BUCKET_NAME="techniecode-qa"
    GOOGLE_CLOUD_PROJECT="tenant1-459420"
    ENCOMPASS_USERNAME="admin@encompass:BE11200014"
    ENCOMPASS_PASSWORD="AHYAIWWMMT" 
    CLIENT_ID="arkdvig"
    CLIENT_SECRET="E7RBTjwqdTjO$P0&8UumSzX$rt@SUoVat8LiOrQfaDs!jko1MgBB4gj*TF7Py*6i"
    ENCOMPASS_AUTH_URL="https://api.elliemae.com/oauth2/v1/token"
    ENCOMPASS_BASE_URL="https://api.elliemae.com/encompass/v3/loans"    
    GCS_CONST_FOLDER="selling-guide"    
    #DOCAI_LOCATION="${var.ocai_location}"
    #DOCUMENT_PROCESSOR_ID = "${google_document_ai_processor.tivaa_document_processor.id}" 
    PIPELINE_REPORT_URL="https://api.elliemae.com/encompass/v3/loanPipeline/report"
    GCS_FOLDER="condos"
    QUESTIONNAIRE_PREFIX="questionnaire/liberty"
    SECRET_KEY = "ETYMO&!0Y6U4W9*!"
}
