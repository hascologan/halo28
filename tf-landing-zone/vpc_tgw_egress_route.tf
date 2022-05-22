###############################################################################
# Get Default TGW Route Table
data "aws_ec2_transit_gateway_route_table" "tgw" {
  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.tgw.id]
  }
}


###############################################################################
# TGW Spoke VPC(s) Route to Hub
resource "aws_ec2_transit_gateway_route" "tgw_to_hub" {
  for_each = local.has_public_subnets

  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw[each.key].id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw.id
}
