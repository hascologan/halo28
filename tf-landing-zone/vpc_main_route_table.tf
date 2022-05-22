###############################################################################
# Default VPC Main Route Table Import
resource "aws_default_route_table" "main" {
  for_each = var.vpcs

  default_route_table_id = aws_vpc.vpc[each.key].default_route_table_id

  tags = {
    Name = replace("${var.project_name}-${each.key}-Main-VRT", " ", "")
  }
}

###############################################################################
# Associatate Private Subnets to Route Table
resource "aws_route_table_association" "private" {
  for_each = {
    for subnet in local.private_subnets : "${subnet.vpc_name}.${subnet.subnet_name}.${subnet.availability_zone}" => subnet
  }

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_default_route_table.main[each.value.vpc_name].id
}
