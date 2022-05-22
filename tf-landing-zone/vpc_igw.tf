###############################################################################
# VPC Internet Gateway
resource "aws_internet_gateway" "igw" {
  for_each = local.has_public_subnets

  vpc_id = aws_vpc.vpc[each.key].id

  tags = {
    Name = replace("${var.project_name}-${each.key}-IGW", " ", "")
  }
}

###############################################################################
# Add IGW Route to Public Route Table
resource "aws_route" "igw" {
  for_each = local.has_public_subnets

  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[each.key].id
}
