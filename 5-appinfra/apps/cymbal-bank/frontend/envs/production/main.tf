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

locals {
  env                           = "production"
  app_namespace                 = "frontend-production"
  app_service_account_name      = "cymbal-bank"
  pod_service_account_principal = "principal://iam.googleapis.com/projects/${local.cluster_project_number}/locations/global/workloadIdentityPools/${local.cluster_project_id}.svc.id.goog/subject/ns/${local.app_namespace}/sa/${local.app_service_account_name}"
}

resource "google_project_iam_member" "fleet_project_roles" {
  for_each = toset(
    [
      "roles/cloudtrace.agent",
      "roles/monitoring.metricWriter"
    ]
  )

  project = local.fleet_project_id
  role    = each.value
  member  = local.pod_service_account_principal
}
