# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# CI trigger configuration
resource "google_cloudbuild_trigger" "ci" {
  name     = "${local.service_clean}-ci"
  project  = var.project_id
  location = var.region

  # TODO: remove after CSR support is removed 
  dynamic "trigger_template" {
    for_each = local.use_csr ? [1] : []
    content {
      branch_name = var.repo_branch
      repo_name   = var.repo_name
      project_id  = var.csr_project_id
    }
  }

  dynamic "repository_event_config" {
    for_each = local.use_csr ? [] : [1]
    content {
      repository = module.cloudbuild_repositories[0].cloud_build_repositories_2nd_gen_repositories[var.repo_name].id
      push {
        branch = var.repo_branch
      }
    }
  }

  included_files = var.ci_build_included_files
  filename       = var.app_build_trigger_yaml

  substitutions = merge(
    {
      _CACHE_URI                 = "gs://${google_storage_bucket.build_cache.name}/${google_storage_bucket_object.cache.name}"
      _CONTAINER_REGISTRY        = "${local.container_registry.location}-docker.pkg.dev/${local.container_registry.project}/${local.container_registry.repository_id}"
      _SOURCE_STAGING_BUCKET     = "gs://${google_storage_bucket.release_source_development.name}"
      _CACHE                     = local.cache_filename
      _CLOUDDEPLOY_PIPELINE_NAME = google_clouddeploy_delivery_pipeline.delivery-pipeline.name
    },
    var.additional_substitutions
  )

  service_account = google_service_account.cloud_build.id
}
