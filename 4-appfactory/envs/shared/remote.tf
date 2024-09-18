/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// These values are retrieved from the saved terraform state of the execution
// of previous step using the terraform_remote_state data source.
locals {
  cluster_service_accounts = flatten([for state in data.terraform_remote_state.multitenant : state.outputs.cluster_service_accounts])
  acronym                  = flatten([for state in data.terraform_remote_state.multitenant : state.outputs.acronyms])[0]
}

data "terraform_remote_state" "multitenant" {
  for_each = var.envs

  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/multi_tenant/${each.key}"
  }
}
