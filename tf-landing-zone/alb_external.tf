###############################################################################
# Create List Of Public Subnets For ALB
locals {
  alb_public_subnets = flatten([
    for vpc_name, vpc_config in var.vpcs : [
      for az, subnets in vpc_config.public_subnets : az
    ] if vpc_name == var.alb_vpc
  ])
}


###############################################################################
# Create ALB
resource "aws_lb" "external" {
  name               = replace("${var.project_name}-${var.alb_vpc}-ALB", " ", "")
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for az in local.alb_public_subnets : aws_subnet.public["${var.alb_vpc}.${var.alb_subnet_name}.${az}"].id]

  enable_deletion_protection = var.alb_external_enable_deletion_protection

  access_logs {
    bucket  = aws_s3_bucket.s3_alb_logs.bucket
    prefix  = "ALB-logs"
    enabled = true
  }

  tags = {
    Name = replace("${var.project_name}-${var.alb_vpc}-ALB", " ", "")
  }
}
