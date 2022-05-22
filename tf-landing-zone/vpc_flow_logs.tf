###############################################################################
# VPC Flow Logs
resource "aws_flow_log" "vpc" {
  depends_on = [aws_s3_bucket_policy.vpc_flow_logs_s3b_policy]

  for_each = var.vpcs

  traffic_type         = "ALL"
  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.vpc_flow_logs_s3b.arn
  vpc_id               = aws_vpc.vpc[each.key].id

  tags = {
    Name = replace("${var.project_name}-${each.key}-VFL", " ", "")
  }
}
