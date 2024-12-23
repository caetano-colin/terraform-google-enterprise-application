# Cymbal Bank deployment example

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_substitutions | A map of additional substitution variables for Google Cloud Build Trigger Specification. All keys must start with an underscore (\_). | `map(string)` | `{}` | no |
| app\_build\_trigger\_yaml | Path to the Cloud Build YAML file for the application | `string` | n/a | yes |
| buckets\_force\_destroy | When deleting the bucket for storing CICD artifacts, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects. | `bool` | `false` | no |
| ci\_build\_included\_files | (Optional) includedFiles are file glob matches using https://golang.org/pkg/path/filepath/#Match extended with support for **. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is empty, then as far as this filter is concerned, we should trigger the build. If any of the files altered in the commit pass the ignoredFiles filter and includedFiles is not empty, then we make sure that at least one of those files matches a includedFiles glob. If not, then we do not trigger a build. | `list(string)` | `[]` | no |
| cluster\_service\_accounts | Cluster services accounts to be granted the Artifact Registry reader role. | `map(string)` | n/a | yes |
| env\_cluster\_membership\_ids | Env Cluster Membership IDs | <pre>map(object({<br>    cluster_membership_ids = list(string)<br>  }))</pre> | n/a | yes |
| project\_id | CI/CD project ID | `string` | n/a | yes |
| region | CI/CD Region (e.g. us-central1) | `string` | n/a | yes |
| repo\_branch | Branch to sync ACM configs from & trigger CICD if pushed to. | `string` | n/a | yes |
| repo\_name | Short version of repository to sync ACM configs from & use source for CI (e.g. 'bank-of-anthos' for https://www.github.com/GoogleCloudPlatform/bank-of-anthos) | `string` | n/a | yes |
| service\_name | service name (e.g. 'transactionhistory') | `string` | n/a | yes |
| team\_name | Team name (e.g. 'ledger'). This will be the prefix to the service CI Build Trigger Name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| clouddeploy\_targets\_names | Cloud deploy targets names. |
| service\_repository\_name | The Source Repository name. |
| service\_repository\_project\_id | The Source Repository project id. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

