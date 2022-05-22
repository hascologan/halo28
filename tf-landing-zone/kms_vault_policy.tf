###############################################################################
# IAM policy to access the kms key used to unseal the vault sever
resource "aws_iam_policy" "kms_vault_pol" {
  name        = replace("${var.project_name}-KMS-Vault-Pol", " ", "")
  description = "Policy to the kms key used to unseal the vault sever"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:DescribeKey",
          "kms:Decrypt"
        ]
        # Resource = ["arn:${data.aws_partition.current.partition}:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/${aws_kms_key.vault_kms.id}"]
        Resource = "*"
      },
    ]
  })
}
