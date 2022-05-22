###############################################################################
# S3 Bucket For S3 Access Logs
resource "aws_s3_bucket" "s3_logs_s3b" {
  bucket = lower(replace("${var.project_name}-s3-logs-${data.aws_caller_identity.current.account_id}-S3B", " ", ""))

  force_destroy = var.force_destroy_s3

  tags = {
    Name = replace("${var.project_name}-s3-logs-${data.aws_caller_identity.current.account_id}-S3B", " ", "")
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
# S3 Bucket For S3 Access Logs ACL
resource "aws_s3_bucket_acl" "s3_logs_s3b_acl" {
  bucket = aws_s3_bucket.s3_logs_s3b.id
  access_control_policy {
    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "WRITE"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}

###############################################################################
# S3 Bucket For S3 Access Logs Object Deletion Policy
resource "aws_s3_bucket_lifecycle_configuration" "s3_logs_s3b_lifecycle" {
  bucket = aws_s3_bucket.s3_logs_s3b.id

  rule {
    id = "object-deletion-rule"
    expiration {
      days = var.s3_objs_expire_days
    }
    status = var.expire_s3_objs
  }
}

###############################################################################
# S3 Bucket For S3 Access Logs Encryption Policy
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_logs_s3b_encryption" {
  bucket = aws_s3_bucket.s3_logs_s3b.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

###############################################################################
# S3 Bucket for S3 Access Logs Bucket Policy
resource "aws_s3_bucket_policy" "s3_logs_s3b_policy" {
  bucket = aws_s3_bucket.s3_logs_s3b.id

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
          "Resource" = aws_s3_bucket.s3_logs_s3b.arn,
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
