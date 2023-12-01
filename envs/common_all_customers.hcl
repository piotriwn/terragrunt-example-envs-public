# parameters that are common to all customers (but can be overriden)
locals {
  # variables for the runner module
  access_token_secret_id  = "gh-access-token"
  common_project          = "common-project-id"
  cloudbuild_gcs_location = "europe-west1"
  trigger_location        = "europe-west1"
  builder_full_name       = "builder-full-name"
  sa_roles_list = [
    "roles/editor",
  ]
  sa_roles_list_common_project = [
    "roles/secretmanager.secretAccessor",
    "roles/artifactregistry.reader",
  ]
}