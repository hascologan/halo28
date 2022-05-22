
###############################################################################
# Spoke VPC(s) Route to TGW
resource "aws_route" "tgw" {
  for_each = local.has_private_subnets_only

  depends_on = [
    aws_ec2_transit_gateway.tgw,
    aws_ec2_transit_gateway_vpc_attachment.tgw
  ]

  route_table_id         = aws_default_route_table.main[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

###############################################################################
# Hub VPC Route to TGW
resource "aws_route" "tgw_hub_to_spoke" {
  for_each = {
    for route in local.public_to_private_routes : "${route.public_vpc}.${route.route}" => route
  }

  depends_on = [
    aws_ec2_transit_gateway.tgw,
    aws_ec2_transit_gateway_vpc_attachment.tgw
  ]

  route_table_id         = aws_route_table.public[each.value.public_vpc].id
  destination_cidr_block = each.value.route
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}
