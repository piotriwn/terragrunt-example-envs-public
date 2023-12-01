# TF, provider, repos, backend paramaters
locals {
  gcs_backend_location    = "europe-west1"
  gcs_backend_name_prefix = "solution-tf-state"

  gcp_tf_provider_constraint = "5.0.0"

  storage_sample_module_name = "storage-module-path"
  random_sample_module_name  = "random-module-path"
  runner_module              = "runner-module-path"
}