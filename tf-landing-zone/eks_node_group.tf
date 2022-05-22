###############################################################################
# EKS Node Group
resource "aws_eks_node_group" "eks" {
  for_each = var.eks_clusters

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEC2ContainerRegistryReadOnly,
  ]

  cluster_name    = aws_eks_cluster.eks[each.key].name
  node_group_name = lower(each.key)
  node_role_arn   = aws_iam_role.eks_node_group[each.key].arn
  subnet_ids = [
    for values in local.private_subnets : aws_subnet.private["${values.vpc_name}.${values.subnet_name}.${values.availability_zone}"].id
    if values.vpc_name == "${each.value.vpc_name}" && values.subnet_name == "${each.value.node_subnet}"
  ]

  # instance_types = each.value.instance_types
  # disk_size      = each.value.disk_size

  scaling_config {
    desired_size = each.value.node_desired_size
    max_size     = each.value.node_max_size
    min_size     = each.value.node_min_size
  }

  launch_template {
    id      = aws_launch_template.eks[each.key].id
    version = aws_launch_template.eks[each.key].latest_version
  }

  tags = {
    Name = replace("${var.project_name}-${each.key}-EKS-NG", " ", "")
  }
}
