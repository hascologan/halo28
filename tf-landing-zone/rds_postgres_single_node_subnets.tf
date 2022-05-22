###############################################################################
# RDS PostgreSQL Single AZ Subnet Group
resource "aws_db_subnet_group" "rds_postgres_single_node" {
  for_each = var.rds_postgres_single_node

  name       = lower(replace("${var.project_name}-${each.value.vpc_name}-${each.key}-SnG", " ", ""))
  subnet_ids = [for az in each.value.subnet_group : aws_subnet.private["${each.value.vpc_name}.${each.value.subnet_name}.${az}"].id]

  tags = {
    Name = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-SnG", " ", "")
  }
}
