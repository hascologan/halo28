###############################################################################
# RDS KMS Customer Managed Key Alias
resource "aws_kms_alias" "rds_kms_alias" {
  name          = "alias/${var.project_name}-rds-kms"
  target_key_id = aws_kms_key.rds_kms.key_id
}

###############################################################################
# RDS Customer Managed Key
resource "aws_kms_key" "rds_kms" {
  description         = "KMS Key for RDS volumes"
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
      ]
    }
  )

  tags = {
    Name = replace("${var.project_name}-RDS-KMS", " ", "")
  }
}
