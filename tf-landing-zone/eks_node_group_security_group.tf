###############################################################################
# Security Group
resource "aws_security_group" "eks_node_group" {
  for_each = var.eks_clusters

  name        = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-ScG", " ", "")
  description = "Security group for ${each.key}"
  vpc_id      = aws_vpc.vpc[each.value.vpc_name].id

  tags = {
    "Name"                              = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-ScG", " ", ""),
    "kubernetes.io/cluster/${each.key}" = "owned"
  }

  lifecycle {
    ignore_changes = [
      ingress,
    ]
  }
}

###############################################################################
# Egress Rule
resource "aws_security_group_rule" "egress_eks_node_group" {
  for_each = var.eks_clusters

  description       = "All Egress rule"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_node_group[each.key].id
}

###############################################################################
# Loopback Rule
resource "aws_security_group_rule" "loopback_eks_node_group" {
  for_each = var.eks_clusters

  description       = "Loopback rule"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.eks_node_group[each.key].id
}

###############################################################################
# EKS Cluster Security Group
resource "aws_security_group_rule" "eks_cluster_security_group" {
  for_each = var.eks_clusters

  description              = "EKS Cluster Security Group"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_eks_cluster.eks[each.key].vpc_config[0].cluster_security_group_id
  security_group_id        = aws_security_group.eks_node_group[each.key].id
}

###############################################################################
# Calculate Ingress Rules
locals {
  eks_security_ingress_rules = flatten([
    for cluster_key, cluster in var.eks_clusters : [
      for ingress_key, ingress in cluster.ingress : {
        cluster_key = cluster_key
        ingress_key = ingress_key
        rule        = ingress
      }
    ]
  ])
}

###############################################################################
# Ingress Rules
resource "aws_security_group_rule" "ingress_eks_node_group" {
  for_each = {
    for rule in local.eks_security_ingress_rules : "${rule.cluster_key}.${rule.ingress_key}" => rule
  }

  description       = each.value.rule.description
  type              = "ingress"
  from_port         = each.value.rule.from_port
  to_port           = each.value.rule.to_port
  protocol          = each.value.rule.protocol
  cidr_blocks       = each.value.rule.cidr_blocks
  security_group_id = aws_security_group.eks_node_group[each.value.cluster_key].id
}
