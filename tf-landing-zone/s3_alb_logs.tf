###############################################################################
# Create ALB Log Store Bucket
resource "aws_s3_bucket" "s3_alb_logs" {
  bucket        = lower(replace("${var.project_name}-alb-logs-${data.aws_caller_identity.current.account_id}-S3B", " ", ""))
  force_destroy = var.force_destroy_s3

  tags = {
    Name = replace("${var.project_name}-ALB-Bucket-${data.aws_caller_identity.current.account_id}-S3B", " ", "")
  }
}

###############################################################################
# S3 ALB Log Store Bucket Object Deletion Policy
resource "aws_s3_bucket_lifecycle_configuration" "s3_alb_logs_lifecycle" {
  bucket = aws_s3_bucket.s3_alb_logs.id

  rule {
    id = "object-deletion-rule"
    expiration {
      days = var.s3_objs_expire_days
    }
    status = var.expire_s3_objs
  }
}

###############################################################################
# S3 ALB Log Store Bucket Encryption Policy
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_alb_logs_encryption" {
  bucket = aws_s3_bucket.s3_alb_logs.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

###############################################################################
# Create ALB Log Store Bucket Policy
data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket_policy" "lb_log_access" {
  bucket = aws_s3_bucket.s3_alb_logs.id
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Sid"    = "Enable IAM User Permissions",
          "Effect" = "Allow",
          "Principal" = {
            "AWS" = "${data.aws_elb_service_account.main.arn}"
          },
          "Action"   = "s3:PutObject",
          "Resource" = "${aws_s3_bucket.s3_alb_logs.arn}/ALB-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        },
        {
          "Sid"       = "AllowSSLRequestsOnly",
          "Effect"    = "Deny",
          "Principal" = "*",
          "Action" = [
            "s3:*"
          ],
          "Resource" = aws_s3_bucket.s3_alb_logs.arn,
          "Condition" = {
            "Bool" = {
              "aws:SecureTransport" = "false"
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
          "Resource" = aws_s3_bucket.s3_alb_logs.arn
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
            "${aws_s3_bucket.s3_alb_logs.arn}/ALB-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
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
