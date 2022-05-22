###############################################################################
# Security Group
resource "aws_security_group" "ec2" {
  for_each = var.ec2_servers

  name        = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-ScG", " ", "")
  description = "Security group for ${each.key}"
  vpc_id      = aws_vpc.vpc[each.value.vpc_name].id

  tags = {
    "Name" = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-ScG", " ", "")
  }
}

###############################################################################
# Egress Rule
resource "aws_security_group_rule" "egress" {
  for_each = var.ec2_servers

  description       = "All Egress rule"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2[each.key].id
}

###############################################################################
# Calculate Ingress Rules
locals {
  security_ingress_rules = flatten([
    for server_key, server in var.ec2_servers : [
      for ingress_key, ingress in server.ingress : {
        server_key  = server_key
        ingress_key = ingress_key
        rule        = ingress
      }
    ]
  ])
}

###############################################################################
# Ingress Rules
resource "aws_security_group_rule" "ingress" {
  for_each = {
    for rule in local.security_ingress_rules : "${rule.server_key}.${rule.ingress_key}" => rule
  }

  description       = each.value.rule.description
  type              = "ingress"
  from_port         = each.value.rule.from_port
  to_port           = each.value.rule.to_port
  protocol          = each.value.rule.protocol
  cidr_blocks       = each.value.rule.cidr_blocks
  security_group_id = aws_security_group.ec2[each.value.server_key].id
}
