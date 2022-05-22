###############################################################################
# Public Subnets
resource "aws_subnet" "public" {
  for_each = {
    for subnet in local.public_subnets : "${subnet.vpc_name}.${subnet.subnet_name}.${subnet.availability_zone}" => subnet
  }

  availability_zone       = join("", [data.aws_region.current.name, each.value.availability_zone])
  cidr_block              = each.value.subnet_cidr
  vpc_id                  = aws_vpc.vpc[each.value.vpc_name].id
  map_public_ip_on_launch = true

  tags = {
    Name = replace("${var.project_name}-${each.value.vpc_name}-${title(each.value.subnet_name)}-${upper(each.value.availability_zone)}-Snt", " ", "")
  }
}
