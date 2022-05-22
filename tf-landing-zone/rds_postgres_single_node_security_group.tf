###############################################################################
# Security Group
resource "aws_security_group" "rds_postgres_single_node" {
  for_each = var.rds_postgres_single_node

  name        = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-ScG", " ", "")
  description = "Security group for ${each.key}"
  vpc_id      = aws_vpc.vpc[each.value.vpc_name].id

  tags = {
    "Name" = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-ScG", " ", "")
  }
}

###############################################################################
# Egress Rule
resource "aws_security_group_rule" "rds_postgres_single_node_egress" {
  for_each = var.rds_postgres_single_node

  description       = "All Egress rule"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_postgres_single_node[each.key].id
}

###############################################################################
# Calculate Ingress Rules
locals {
  rds_postgres_single_node_ingress_rules = flatten([
    for db_key, db in var.rds_postgres_single_node : [
      for ingress_key, ingress in db.ingress : {
        db_key      = db_key
        ingress_key = ingress_key
        rule        = ingress
      }
    ]
  ])
}

###############################################################################
# Ingress Rules
resource "aws_security_group_rule" "rds_postgres_single_node_ingress" {
  for_each = {
    for rule in local.rds_postgres_single_node_ingress_rules : "${rule.db_key}.${rule.ingress_key}" => rule
  }

  description       = each.value.rule.description
  type              = "ingress"
  from_port         = each.value.rule.from_port
  to_port           = each.value.rule.to_port
  protocol          = each.value.rule.protocol
  cidr_blocks       = each.value.rule.cidr_blocks
  security_group_id = aws_security_group.rds_postgres_single_node[each.value.db_key].id
}
