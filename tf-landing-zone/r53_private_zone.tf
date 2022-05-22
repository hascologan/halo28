###############################################################################
# Find First VPC With Public Subnets and Create List Of Other VPC(s)
locals {
  dns_account = element(tolist(local.has_public_subnets), 0)
  non_dns_account = toset([
    for vpc_key, vpc_value in var.vpcs : vpc_key if vpc_key != local.dns_account
  ])
}

###############################################################################
# Create Private DNS Zone
resource "aws_route53_zone" "private" {
  name          = var.apex_domain
  comment       = "Private DNS for ${var.apex_domain}"
  force_destroy = true

  vpc {
    vpc_id = aws_vpc.vpc[local.dns_account].id
  }

  tags = {
    Name = replace("${var.project_name}-Private-R53", " ", "")
  }

  lifecycle {
    ignore_changes = [
      vpc,
    ]
  }
}

###############################################################################
# Attach Other VPC(s) to Private Route 53
resource "aws_route53_zone_association" "private" {
  for_each = local.non_dns_account

  zone_id = aws_route53_zone.private.zone_id
  vpc_id  = aws_vpc.vpc[each.key].id
}
