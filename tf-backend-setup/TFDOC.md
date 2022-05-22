# TF-Backend-Setup Resource Index

<!-- prettier-ignore-start -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.tf_lock_status_ddb](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/dynamodb_table) | resource |
| [aws_iam_instance_profile.tf_bootstrap](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.tf_state_lock_pol](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.tf_bootstrap](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.tf_bootstrap](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.tf_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.tf_kms](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_key) | resource |
| [aws_s3_bucket.tf_statefile_s3](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.s3_logs_s3b_policy](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.tf_statefile_s3_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.tf_statefile_s3_encryption](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.tf_statefile_s3_versioning](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_profile"></a> [profile](#input\_profile) | This is the AWS profile name as set in the shared credentials file. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Unique alias for project related resources. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region. Required: explicit or sourced here or from the AWS\_DEFAULT\_REGION environment variable. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tf_build_role"></a> [tf\_build\_role](#output\_tf\_build\_role) | The arn of the build role to assume |
| <a name="output_tf_lock_status_DDB"></a> [tf\_lock\_status\_DDB](#output\_tf\_lock\_status\_DDB) | The name of the DynamoDB table used for Terraform lock status |
| <a name="output_tf_statefile_s3"></a> [tf\_statefile\_s3](#output\_tf\_statefile\_s3) | The name of the S3 bucket to use for Terraform statefiles |
<!-- END_TF_DOCS -->
<!-- prettier-ignore-end -->
