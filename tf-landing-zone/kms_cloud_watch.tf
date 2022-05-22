###############################################################################
# CWLogs KMS Customer Managed Key Alias
resource "aws_kms_alias" "cwlogs_kms_alias" {
  name          = "alias/${var.project_name}-cwlogs-kms"
  target_key_id = aws_kms_key.cwlogs_kms.key_id
}

###############################################################################
# CWLogs Customer Managed Key
resource "aws_kms_key" "cwlogs_kms" {
  description         = "KMS Key for cloud watch logs"
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
            "Service" = "logs.${var.region}.amazonaws.com"
          },
          "Action" = [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
          ],
          "Resource" = "*"
          "Condition" = {
            "ArnLike" = {
              "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
            }
          }
        }
      ]
    }
  )

  tags = {
    Name = replace("${var.project_name}-Cloud-Watch-Logs-KMS", " ", "")
  }
}
