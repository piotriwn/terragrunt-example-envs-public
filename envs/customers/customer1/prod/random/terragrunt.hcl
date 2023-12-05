locals {
  random_module_tag = "v1.1"
}

include "root" {
  path   = find_in_parent_folders("terragrunt.hcl")
  expose = true
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

terraform {
  source = "git::https://github.com/${include.root.locals.common_general_values.random_sample_module_name}//?ref=${local.random_module_tag}"
}

inputs = {
  length = include.root.locals.merged_values.random_string_length
}