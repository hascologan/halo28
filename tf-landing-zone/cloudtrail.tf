###############################################################################
# Enable Cloudtrail for Regoin
resource "aws_cloudtrail" "enable" {
  depends_on = [aws_s3_bucket_policy.cloudtrail_s3b_policy]

  name           = replace("${var.project_name}-${data.aws_caller_identity.current.account_id}-CTr", " ", "")
  s3_bucket_name = aws_s3_bucket.cloudtrail_s3b.id

  tags = {
    Name = replace("${var.project_name}-${data.aws_caller_identity.current.account_id}-CTr", " ", "")
  }
}
