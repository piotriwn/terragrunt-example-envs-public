locals {
  # set the suffix of the bucket hosting a TF backend for each module invocation
  backend_bucket_suffix = replace(trimprefix(path_relative_to_include(), "customers/"), "/", "-")

  # load common_general.hcl
  common_general_values = read_terragrunt_config(find_in_parent_folders("common_general.hcl")).locals

  # load common_all_customers.hcl
  common_all_customers_values = read_terragrunt_config(find_in_parent_folders("common_all_customers.hcl")).locals

  # load customer.hcl
  customer_values = read_terragrunt_config(find_in_parent_folders("customer.hcl")).locals

  # load environment.hcl
  environment_values = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals

  # commmon.hcl does not contain input values for the modules
  merged_values = merge(
    local.common_all_customers_values,
    local.customer_values,
    local.environment_values
  )
}

# it will auto-generate GCS bucket - no need to create it before-hand
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

