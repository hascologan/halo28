###############################################################################
# VPC Endpoint for SSM
resource "aws_vpc_endpoint" "ssm" {
  for_each = {
    for key, values in var.vpcs : key => values
    if values.endpoint_ssm
  }

  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_id              = aws_vpc.vpc[each.key].id
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoints[each.key].id]
  subnet_ids = [
    for values in local.private_subnets : aws_subnet.private["${values.vpc_name}.${values.subnet_name}.${values.availability_zone}"].id
    if values.vpc_name == "${each.key}" && values.subnet_name == "${each.value.endpoint_subnet}"
  ]

  tags = {
    Name = replace("${var.project_name}-${each.key}-SSM-VEp", " ", "")
  }
}

###############################################################################
# VPC Endpoint for SSM Messages
resource "aws_vpc_endpoint" "ssm_messages" {
  for_each = {
    for key, values in var.vpcs : key => values
    if values.endpoint_ssm
  }

  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_id              = aws_vpc.vpc[each.key].id
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoints[each.key].id]
  subnet_ids = [
    for values in local.private_subnets : aws_subnet.private["${values.vpc_name}.${values.subnet_name}.${values.availability_zone}"].id
    if values.vpc_name == "${each.key}" && values.subnet_name == "${each.value.endpoint_subnet}"
  ]

  tags = {
    Name = replace("${var.project_name}-${each.key}-SSM-Messages-VEp", " ", "")
  }
}

###############################################################################
# VPC Endpoint for EC2 Messages
resource "aws_vpc_endpoint" "ec2_messages" {
  for_each = {
    for key, values in var.vpcs : key => values
    if values.endpoint_ssm
  }

  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_id              = aws_vpc.vpc[each.key].id
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoints[each.key].id]
  subnet_ids = [
    for values in local.private_subnets : aws_subnet.private["${values.vpc_name}.${values.subnet_name}.${values.availability_zone}"].id
    if values.vpc_name == "${each.key}" && values.subnet_name == "${each.value.endpoint_subnet}"
  ]

  tags = {
    Name = replace("${var.project_name}-${each.key}-EC2-Messages-VEp", " ", "")
  }
}
