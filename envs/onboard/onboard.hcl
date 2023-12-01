locals {
  backend_bucket_suffix = "runner-${replace(path_relative_to_include(), "/", "-")}"

  customer_directory_name = split("/", path_relative_to_include())[0]
  customer_environment    = split("/", path_relative_to_include())[1]

  common_general_values = read_terragrunt_config(find_in_parent_folders("common_general.hcl")).locals

  common_all_customers_values = read_terragrunt_config(find_in_parent_folders("common_all_customers.hcl")).locals

  customer_values = read_terragrunt_config("${get_repo_root()}/envs/customers/${local.customer_directory_name}/customer.hcl").locals

  merged_values = merge(
    local.common_all_customers_values,
    local.customer_values,
  )
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    project  = local.merged_values.customer_dedicated_project_id
    location = local.common_general_values.gcs_backend_location
    bucket   = "${local.common_general_values.gcs_backend_name_prefix}-${local.backend_bucket_suffix}"
    prefix   = "terraform/tfstate"
  }
}


inputs = {
  resource_name_prefix           = "${local.merged_values.customer_name}-"
  resource_name_suffix           = "-${local.customer_environment}"
  project_id                     = local.merged_values.customer_dedicated_project_id
  included_files_list            = ["envs/*", "/envs/customers/${local.customer_directory_name}/customer.hcl", "envs/customers/${local.customer_directory_name}/${local.customer_environment}/**"]
  sa_roles_list                  = local.merged_values.sa_roles_list
  sa_roles_list_common_project   = local.merged_values.sa_roles_list_common_project
  cloudbuild_gcs_location        = local.merged_values.cloudbuild_gcs_location
  trigger_location               = local.merged_values.trigger_location
  trigger_purpose                = "exec"
  common_project                 = local.merged_values.common_project
  cb_repository_id               = "projects/${local.merged_values.customer_dedicated_project_id}/locations/${local.merged_values.trigger_location}/connections/CONNECTION_NAME/repositories/REPO_NAME"
  access_token_secret_id         = local.merged_values.access_token_secret_id
  terragrunt_run_level_directory = "envs/customers/${local.customer_directory_name}/${local.customer_environment}"
}