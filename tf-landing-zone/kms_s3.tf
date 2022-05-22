###############################################################################
# S3 KMS Customer Managed Key Alias
resource "aws_kms_alias" "s3_kms_alias" {
  name          = "alias/${var.project_name}-s3-kms"
  target_key_id = aws_kms_key.s3_kms.key_id
}

###############################################################################
# S3 Customer Managed Key
resource "aws_kms_key" "s3_kms" {
  description         = "KMS Key for S3 Buckets"
  enable_key_rotation = true

  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Sid"    = "Enable IAM User Permissions",
          "Effect" = "Allow",
          "Principal" = {
            "AWS" = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
          },
          "Action"   = "kms:*",
          "Resource" = "*"
        },
        {
          "Sid"    = "Enable access for logs delivery service",
          "Effect" = "Allow",
          "Principal" = {
            "Service" = "delivery.logs.amazonaws.com"
          },
          "Action" = [
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Encrypt",
            "kms:DescribeKey",
            "kms:Decrypt"
          ],
          "Resource" = "*"
        },
        {
          "Sid"    = "Enable access for KMS key for resources in account",
          "Effect" = "Allow",
          "Principal" = {
            "AWS" = "*"
          },
          "Action" = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:CreateGrant",
            "kms:DescribeKey"
          ],
          "Resource" = "*",
          "Condition" = {
            "StringEquals" = {
              "kms:CallerAccount" = "${data.aws_caller_identity.current.account_id}"
            }
          }
        }
      ]
    }
  )

  tags = {
    Name = replace("${var.project_name}-S3-KMS", " ", "")
  }
}
