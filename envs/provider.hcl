locals {
  # load common_general.hcl
  common_general_values = read_terragrunt_config(find_in_parent_folders("common_general.hcl")).locals
}

# generate provider config
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "google" {
        version = "${local.common_general_values.gcp_tf_provider_constraint}"
    }
  EOF
}