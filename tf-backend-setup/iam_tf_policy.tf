###############################################################################
# IAM policy to access the S3 bucket and DynamoDB table
resource "aws_iam_policy" "tf_state_lock_pol" {
  name        = replace("${var.project_name}-TF-Lock-Pol", " ", "")
  description = "Policy to access S3 and DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = ["arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.tf_statefile_s3.id}"]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = ["arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.tf_statefile_s3.id}/*"]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = ["arn:${data.aws_partition.current.partition}:dynamodb:*:*:table/${aws_dynamodb_table.tf_lock_status_ddb.id}"]
      },
      {
        Effect = "Allow"
        "Action" : [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Resource = [aws_kms_key.tf_kms.arn]
    }]
  })
}
