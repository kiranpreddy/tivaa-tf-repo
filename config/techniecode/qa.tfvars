# config/techniecode/qa.tfvars
gcp_project_id     = "techniecode-liberty-qa"
tenant_name        = "techniecode-liberty-qa"
gcp_region         = "us-central1"
docker_image_uri   = "gcr.io/techniecode-liberty-qa/techniecode-aicondoreviewapi_libertyqa:latest"
service_account_email = "harsha.test7@techniecode.com"
allow_public_access   = true
app_prefix = "techniecode"
app_name   = "aicondoreviewapi"
app_env    = "libertyqa"


environment_variables = {
  ENCOMPASS_USERNAME="techniecode@encompass:TEBE11146772"
  ENCOMPASS_PASSWORD="Test1236!lib"
  CLIENT_ID="uol8gfd"
  CLIENT_SECRET="fjKEqRbD1wKp44vksM59TsnJdcQtAp9TIWGyA@B$^mF@CEZ13@$Fs7@8k9wU1mA9"
  #SECRET_KEY           = "ETYMO&!0Y6U4W9*!"
  #DOCAI_PROCESSOR_ID   = "9e317bd672f0ccc3"
}
