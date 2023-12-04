locals {
  storage_module_tag = "v1.1"
}

include "root" {
  path   = find_in_parent_folders("terragrunt.hcl")
  expose = true
}

# you can override provider config instaed of including it
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "google" {
        version = "5.1.0"
    }
  EOF
}

terraform {
  source = "git::https://github.com/${include.root.locals.common_general_values.storage_sample_module_name}//?ref=${local.storage_module_tag}"
}

dependency "random" {
  config_path = "../random"

  # https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#unapplied-dependency-and-mock-outputs
  mock_outputs = {
    string = "temporary-dummy-string"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  project_id = include.root.locals.merged_values.customer_dedicated_project_id
  name       = "${include.root.locals.merged_values.bucket_name_prefix}-${include.root.locals.merged_values.customer_name}-${dependency.random.outputs.string}"
  location   = include.root.locals.merged_values.bucket_location
}