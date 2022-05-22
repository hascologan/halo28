###############################################################################
# Inline policy for S3 Access
resource "aws_iam_role_policy" "eks_s3b" {
  for_each = {
    for key, value in var.eks_clusters : key => value if value.s3_storage
  }

  name = replace("${var.project_name}-EKS-S3-Access", " ", "")
  role = aws_iam_role.eks_node_group[each.key].name

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetBucketLocation",
            "s3:ListAllMyBuckets",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "s3:ListBucket",
          ]
          Effect   = "Allow"
          Resource = "${aws_s3_bucket.eks_s3b[each.key].arn}"
        },
        {
          Action = [
            "s3:AbortMultipartUpload",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:DeleteObject",
          ]
          Effect   = "Allow"
          Resource = "${aws_s3_bucket.eks_s3b[each.key].arn}/*"
        },
      ]
    }
  )

}
