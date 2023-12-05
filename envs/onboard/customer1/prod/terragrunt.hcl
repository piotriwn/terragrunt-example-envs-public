locals {
  # which version of the "runner" module will be deployed for that customer in a given environment
  runner_module_tag = "v1.1"

  # which version of the Docker Terragrunt image will be used in the newly-generated triggers
  terragrunt_image_version = "v1.1"
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "onboard" {
  path   = find_in_parent_folders("onboard.hcl")
  expose = true
}

terraform {
  source = "git::https://github.com/${include.onboard.locals.common_general_values.runner_module}//?ref=${local.runner_module_tag}"
}

inputs = {
  builder_full_name = "${include.onboard.locals.merged_values.builder_full_name}:${local.terragrunt_image_version}"
}

