###############################################################################
# Inline policy for S3 Access
resource "aws_iam_role_policy" "ec2_s3b" {
  for_each = {
    for key, value in var.ec2_servers : key => value if value.s3_storage
  }

  name = replace("${var.project_name}-EC2-S3-Access", " ", "")
  role = aws_iam_role.ec2[each.key].name

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:ListAllMyBuckets",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "s3:AbortMultipartUpload",
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:DeleteObject",
            "s3:ListBucket",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation",
            "s3:ListBucketMultipartUploads",
            "s3:GetLifecycleConfiguration",
            "s3:PutLifecycleConfiguration",
            "s3:PutObjectTagging",
            "s3:GetObjectTagging",
            "s3:DeleteObjectTagging",
          ]
          Effect = "Allow"
          Resource = [
            "${aws_s3_bucket.ec2_s3b[each.key].arn}",
            "${aws_s3_bucket.ec2_s3b[each.key].arn}/*",
          ]
        },
      ]
    }
  )
}
