###############################################################################
# VPC Endpoint(s)
resource "aws_vpc_endpoint" "ecr_docker" {
  for_each = {
    for key, values in var.vpcs : key => values
    if values.endpoint_ecr_docker
  }

  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_id              = aws_vpc.vpc[each.key].id
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoints[each.key].id]
  subnet_ids = [
    for values in local.private_subnets : aws_subnet.private["${values.vpc_name}.${values.subnet_name}.${values.availability_zone}"].id
    if values.vpc_name == "${each.key}" && values.subnet_name == "${each.value.endpoint_subnet}"
  ]

  tags = {
    Name = replace("${var.project_name}-${each.key}-ECR-Docker-VEp", " ", "")
  }

  #---------------------------------------------#
  # Required for Deloitte OneCloud Environments #
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
  #---------------------------------------------#
}
