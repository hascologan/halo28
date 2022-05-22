###############################################################################
# Create VPC
resource "aws_vpc" "vpc" {
  for_each = var.vpcs

  cidr_block           = each.value.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.instance_tenancy

  tags = {
    Name = replace("${var.project_name}-${each.key}-VPC", " ", "")
  }
}
