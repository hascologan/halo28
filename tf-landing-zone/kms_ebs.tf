###############################################################################
# EBS KMS Customer Managed Key Alias
resource "aws_kms_alias" "ebs_kms_alias" {
  name          = "alias/${var.project_name}-ebs-kms"
  target_key_id = aws_kms_key.ebs_kms.key_id
}

###############################################################################
# EBS Customer Managed Key
resource "aws_kms_key" "ebs_kms" {
  description         = "KMS Key for ebs volumes"
  enable_key_rotation = true

  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Sid"    = "Allow access through EBS for all principals in the account that are authorized to use EBS",
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
              "kms:ViaService"    = "ec2.${var.region}.amazonaws.com",
              "kms:CallerAccount" = "${data.aws_caller_identity.current.account_id}"
            }
          }
        },
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
    Name = replace("${var.project_name}-EBS-KMS", " ", "")
  }
}
