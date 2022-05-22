###############################################################################
# VPC Endpoint(s)
resource "aws_vpc_endpoint" "s3" {
  for_each = {
    for key, values in var.vpcs : key => values
    if values.endpoint_s3
  }

  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_id            = aws_vpc.vpc[each.key].id
  route_table_ids   = [aws_default_route_table.main[each.key].id]

  policy = jsonencode(
    {
      "Version" = "2012-10-17"
      "Statement" = [
        {
          "Effect"    = "Allow"
          "Principal" = "*"
          "Action"    = "*"
          "Resource"  = "*"
        }
      ]
    }
  )

  tags = {
    Name = replace("${var.project_name}-${each.key}-S3-VEp", " ", "")
  }

  #---------------------------------------------#
  # Required for Deloitte OneCloud Environments #
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
  #---------------------------------------------#
}
