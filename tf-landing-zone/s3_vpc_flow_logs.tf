###############################################################################
# VPC Flow Logs S3 Logging Bucket
resource "aws_s3_bucket" "vpc_flow_logs_s3b" {
  bucket = lower(replace("${var.project_name}-vpc-flow-logs-${data.aws_caller_identity.current.account_id}-S3B", " ", ""))

  force_destroy = var.force_destroy_s3

  tags = {
    Name = replace("${var.project_name}-vpc-flow-logs-${data.aws_caller_identity.current.account_id}-S3B", " ", "")
  }
}

###############################################################################
# VPC Flow Logs S3 Logging Bucket Encryption Using KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "vpc_flow_logs_s3b_encryption" {
  bucket = aws_s3_bucket.vpc_flow_logs_s3b.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

###############################################################################
# VPC Flow Logs S3 Logging Bucket for S3 logs
resource "aws_s3_bucket_logging" "vpc_flow_logs_s3b_logs" {
  bucket = aws_s3_bucket.vpc_flow_logs_s3b.id

  target_bucket = aws_s3_bucket.s3_logs_s3b.id
  target_prefix = "cloudtrail"
}

###############################################################################
# VPC Flow Logs S3 Logging Bucket Object Deletion Policy
resource "aws_s3_bucket_lifecycle_configuration" "vpc_flow_logs_s3b_lifecycle" {
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
# VPC Flow Logs S3 Logging Bucket Policy
resource "aws_s3_bucket_policy" "vpc_flow_logs_s3b_policy" {
  bucket = aws_s3_bucket.vpc_flow_logs_s3b.id

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
          "Resource" = aws_s3_bucket.vpc_flow_logs_s3b.arn,
          "Condition" = {
            "Bool" = {
              "aws:SecureTransport" : "false"
            }
          }
        },
        {
          "Sid"    = "AWSLogDeliveryAclCheck",
          "Effect" = "Allow",
          "Principal" = {
            "Service" = [
              "delivery.logs.amazonaws.com"
            ]
          },
          "Action" = [
            "s3:GetBucketAcl"
          ],
          "Resource" = aws_s3_bucket.vpc_flow_logs_s3b.arn
        },
        {
          "Sid"    = "AWSLogDeliveryWrite",
          "Effect" = "Allow",
          "Principal" = {
            "Service" = [
              "delivery.logs.amazonaws.com"
            ]
          },
          "Action" = [
            "s3:PutObject"
          ],
          "Resource" = [
            "${aws_s3_bucket.vpc_flow_logs_s3b.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
          ],
          "Condition" = {
            "StringEquals" = {
              "s3:x-amz-acl" = "bucket-owner-full-control"
            }
          }
        }
      ]
    }
  )
}
