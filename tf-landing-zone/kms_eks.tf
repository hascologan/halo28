###############################################################################
# EKS KMS Customer Managed Key Alias
resource "aws_kms_alias" "eks_kms_alias" {
  name          = "alias/${var.project_name}-eks-kms"
  target_key_id = aws_kms_key.eks_kms.key_id
}

###############################################################################
# EKS Customer Managed Key
resource "aws_kms_key" "eks_kms" {
  description         = "KMS Key for EKS volumes"
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
    Name = replace("${var.project_name}-EKS-KMS", " ", "")
  }
}
