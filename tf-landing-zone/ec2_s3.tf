###############################################################################
# S3 EC2 Storage Bucket
resource "aws_s3_bucket" "ec2_s3b" {
  for_each = {
    for key, value in var.ec2_servers : key => value if value.s3_storage
  }

  bucket = lower(replace("${var.project_name}-${each.value.vpc_name}-${each.key}-${data.aws_caller_identity.current.account_id}-S3B", " ", ""))

  force_destroy = var.force_destroy_s3

  tags = {
    Name = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-${data.aws_caller_identity.current.account_id}-S3B", " ", "")
  }
  #---------------------------------------------#
  # Required for Deloitte FedCloud Environments #
  lifecycle {
    ignore_changes = [
      logging,
    ]
  }
  #---------------------------------------------#
}

###############################################################################
# S3 EC2 Storage Encryption Using KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "ec2_s3b_encryption" {
  for_each = aws_s3_bucket.ec2_s3b
  bucket   = aws_s3_bucket.ec2_s3b[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

###############################################################################
# S3 EC2 Storage Bucket for S3 logs
resource "aws_s3_bucket_logging" "ec2_s3b_logs" {
  for_each = aws_s3_bucket.ec2_s3b
  bucket   = aws_s3_bucket.ec2_s3b[each.key].id

  target_bucket = aws_s3_bucket.s3_logs_s3b.id
  target_prefix = each.key
}

###############################################################################
# S3 EC2 Logging Bucket Object Deletion Policy
resource "aws_s3_bucket_lifecycle_configuration" "ec2_s3b_lifecycle" {
  bucket = aws_s3_bucket.cloudtrail_s3b.id

  rule {
    id = "object-deletion-rule"
    expiration {
      days = var.s3_objs_expire_days
    }
    status = var.expire_s3_objs
  }
}

###############################################################################
# S3 Bucket for EC2 Storage Bucket Policy
resource "aws_s3_bucket_policy" "ec2_logs_s3b_policy" {
  for_each = aws_s3_bucket.ec2_s3b

  bucket = aws_s3_bucket.ec2_s3b[each.key].id

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
          "Resource" = [
            aws_s3_bucket.ec2_s3b[each.key].arn,
            "${aws_s3_bucket.ec2_s3b[each.key].arn}/*"
          ]
          "Condition" : {
            "Bool" : {
              "aws:SecureTransport" = "false"
            }
          }
        }
      ]
    }
  )
}
