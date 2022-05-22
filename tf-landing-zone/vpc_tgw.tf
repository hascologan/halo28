###############################################################################
# Transit Gateway
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = replace("${var.project_name}-TGW", " ", "")
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = replace("${var.project_name}-TGW", " ", "")
  }
}
