###############################################################################
# Private Subnets
resource "aws_subnet" "private" {
  for_each = {
    for subnet in local.private_subnets : "${subnet.vpc_name}.${subnet.subnet_name}.${subnet.availability_zone}" => subnet
  }

  availability_zone = join("", [data.aws_region.current.name, each.value.availability_zone])
  cidr_block        = each.value.subnet_cidr
  vpc_id            = aws_vpc.vpc[each.value.vpc_name].id

  tags = merge(
    tomap(
      {
        for eks_key, eks_values in var.eks_clusters : "kubernetes.io/cluster/${eks_key}" => "shared" if eks_values.vpc_name == each.value.vpc_name && eks_values.node_subnet == each.value.subnet_name
      }
    ),
    tomap(
      {
        for eks_key, eks_values in var.eks_clusters : "kubernetes.io/role/${eks_values.elb_type}" => 1 if eks_values.vpc_name == each.value.vpc_name && eks_values.node_subnet == each.value.subnet_name
      }
    ),
    {
      Name = replace("${var.project_name}-${each.value.vpc_name}-${title(each.value.subnet_name)}-${upper(each.value.availability_zone)}-Snt", " ", "")
    },
  )
}
