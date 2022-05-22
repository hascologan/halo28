###############################################################################
# Find TGW Subnets Per VPC
data "aws_subnets" "tgw" {
  for_each = var.vpcs

  depends_on = [
    aws_subnet.private
  ]
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc[each.key].id]
  }

  tags = {
    Name = replace("${var.project_name}-${each.key}-Tgw-*-Snt", " ", "")
  }
}

###############################################################################
# TGW Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw" {
  for_each = data.aws_subnets.tgw

  subnet_ids         = each.value.ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc[each.key].id

  tags = {
    Name = replace("${var.project_name}-${each.key}-TGA", " ", "")
  }
}
