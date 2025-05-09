<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cors"></a> [cors](#input\_cors) | CORS configuration for the bucket | <pre>list(object({<br/>    max_age_seconds  = optional(number)<br/>    method           = list(string)<br/>    origin           = list(string)<br/>    response_header  = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | Encryption configuration for the bucket | <pre>object({<br/>    default_kms_key_name = string<br/>  })</pre> | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to allow force destroy of the bucket | `bool` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location of the Storage Bucket | `string` | n/a | yes |
| <a name="input_logging"></a> [logging](#input\_logging) | Logging configuration for the bucket | <pre>object({<br/>    log_bucket        = string<br/>    log_object_prefix = string<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Storage Bucket | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the GCP project | `string` | n/a | yes |
| <a name="input_public_access_prevention"></a> [public\_access\_prevention](#input\_public\_access\_prevention) | Public access prevention setting (e.g., enforced, inherited) | `string` | n/a | yes |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | The storage class of the Storage Bucket (e.g., STANDARD) | `string` | n/a | yes |
| <a name="input_uniform_bucket_level_access"></a> [uniform\_bucket\_level\_access](#input\_uniform\_bucket\_level\_access) | Whether uniform bucket-level access is enabled | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | The name of the created Storage Bucket |
<!-- END_TF_DOCS -->