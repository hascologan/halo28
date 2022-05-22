###############################################################################
# EIP for NAT Gateway
resource "aws_eip" "nat" {
  for_each = local.has_public_subnets

  vpc = true

  tags = {
    Name = replace("${var.project_name}-${each.key}-NAT-EIP", " ", "")
  }
}

###############################################################################
# EIP for NAT Gateway
resource "aws_nat_gateway" "ngw" {
  for_each = local.has_public_subnets

  allocation_id = aws_eip.nat[each.key].id
  subnet_id = aws_subnet.public[
    element([
      for value in local.public_subnets : "${value.vpc_name}.${value.subnet_name}.${value.availability_zone}"
      if value.vpc_name == "Network"
    ], 0)
  ].id

  tags = {
    Name = replace("${var.project_name}-${each.key}-NAT", " ", "")
  }
}

###############################################################################
# Add NGW Route to Public Route Main Table
resource "aws_route" "ngw" {
  for_each = local.has_public_subnets

  route_table_id         = aws_default_route_table.main[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw[each.key].id
}
