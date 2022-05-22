###############################################################################
# VAULT KMS Customer Managed Key Alias
resource "aws_kms_alias" "vault_kms_alias" {
  name          = "alias/${var.project_name}-vault-kms"
  target_key_id = aws_kms_key.vault_kms.key_id
}

###############################################################################
# VAULT Customer Managed Key
resource "aws_kms_key" "vault_kms" {
  description         = "KMS Key for unwrapping vault sever"
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
    Name = replace("${var.project_name}-Vault-KMS", " ", "")
  }
}
