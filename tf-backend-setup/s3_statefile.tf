###############################################################################
# S3 Bucket For Holding Terraform Statefile
resource "aws_s3_bucket" "tf_statefile_s3" {
  bucket = lower(replace("${var.project_name}-terraform-statefile-${data.aws_caller_identity.current.account_id}-S3B", " ", ""))

  tags = {
    Name = replace("${var.project_name}-terraform-statefile-${data.aws_caller_identity.current.account_id}-S3B", " ", "")
  }

  #---------------------------------------------#
  # Required for Deloitte OneCloud Environments #
  lifecycle {
    ignore_changes = [
      logging,
    ]
  }
}

###############################################################################
# S3 Bucket for S3 Holding Terraform Statefile Encryption Using KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_statefile_s3_encryption" {
  bucket = aws_s3_bucket.tf_statefile_s3.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tf_kms.key_id
      sse_algorithm     = "aws:kms"
    }
  }
}

###############################################################################
# S3 Bucket for S3 Holding Terraform Statefile Versioning Enabled
resource "aws_s3_bucket_versioning" "tf_statefile_s3_versioning" {
  bucket = aws_s3_bucket.tf_statefile_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

###############################################################################
# S3 Bucket for S3 Holding Terraform Statefile Public Access Block
resource "aws_s3_bucket_public_access_block" "tf_statefile_s3_public_access_block" {
  bucket                  = aws_s3_bucket.tf_statefile_s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

###############################################################################
# S3 Bucket for S3 Holding Terraform Statefile SSL Restrict Policy
resource "aws_s3_bucket_policy" "s3_logs_s3b_policy" {
  bucket = aws_s3_bucket.tf_statefile_s3.id

  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Sid"       = "AllowSSLRequestsOnly",
          "Effect"    = "Deny",
          "Principal" = "*",
          "Action" = [
            "s3:*"
          ],
          "Resource" = aws_s3_bucket.tf_statefile_s3.arn,
          "Condition" = {
            "Bool" = {
              "aws:SecureTransport" = "false"
            }
          }
        }
      ]
    }
  )
}
