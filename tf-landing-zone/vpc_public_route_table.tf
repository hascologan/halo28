###############################################################################
# Main VPC Route Table
resource "aws_route_table" "public" {
  for_each = local.has_public_subnets

  vpc_id = aws_vpc.vpc[each.key].id

  tags = {
    Name = replace("${var.project_name}-${each.key}-Public-VRT", " ", "")
  }
}

###############################################################################
# Associatate Public Subnets to Route Table
resource "aws_route_table_association" "public" {
  for_each = {
    for subnet in local.public_subnets : "${subnet.vpc_name}.${subnet.subnet_name}.${subnet.availability_zone}" => subnet
  }

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.value.vpc_name].id
}
