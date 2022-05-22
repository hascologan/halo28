###############################################################################
# Security Group
resource "aws_security_group" "vpc_endpoints" {
  for_each = {
    for key, values in var.vpcs : key => values
    if values.endpoint_ec2 || values.endpoint_ecr_api || values.endpoint_ecr_docker || values.endpoint_logs || values.endpoint_sts
  }

  name        = replace("${var.project_name}-${each.key}-Endpoint-ScG", " ", "")
  description = "Security group for ${each.key}"
  vpc_id      = aws_vpc.vpc[each.key].id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc[each.key].cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = replace("${var.project_name}-${each.key}-Endpoint-ScG", " ", "")
  }
}
