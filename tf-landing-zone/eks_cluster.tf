###############################################################################
# EKS Contoller
resource "aws_eks_cluster" "eks" {
  for_each = var.eks_clusters

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_controller_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_controller_AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.eks,
  ]

  name     = lower(each.key)
  version  = each.value.version
  role_arn = aws_iam_role.eks_controller[each.key].arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_security_group.eks_control_plane[each.key].id]
    subnet_ids = [
      for values in local.private_subnets : aws_subnet.private["${values.vpc_name}.${values.subnet_name}.${values.availability_zone}"].id
      if values.vpc_name == "${each.value.vpc_name}" && values.subnet_name == "${each.value.controller_subnet}"
    ]
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_kms.arn
    }
    resources = ["secrets"]
  }

  tags = {
    Name = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-EKS", " ", "")
  }
}
