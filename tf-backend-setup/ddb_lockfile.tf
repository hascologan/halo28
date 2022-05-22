###############################################################################
# DynamoDB table for holding Terraform lock state
resource "aws_dynamodb_table" "tf_lock_status_ddb" {
  name           = replace("${var.project_name}-Terraform-Lock-Status-DDB", " ", "")
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.tf_kms.arn
  }

  tags = {
    Name = replace("${var.project_name}-Terraform-Lock-Status-DDB", " ", "")
  }
}
