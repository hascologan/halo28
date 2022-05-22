output "tf_statefile_s3" {
  value       = aws_s3_bucket.tf_statefile_s3.bucket
  description = "The name of the S3 bucket to use for Terraform statefiles"
}

output "tf_lock_status_DDB" {
  value       = aws_dynamodb_table.tf_lock_status_ddb.id
  description = "The name of the DynamoDB table used for Terraform lock status"
}

output "tf_build_role" {
  value       = aws_iam_role.tf_bootstrap.arn
  description = "The arn of the build role to assume"
}
