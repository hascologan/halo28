###############################################################################
# EKS Node Group Add on
resource "aws_eks_addon" "cni" {
  for_each = var.eks_clusters

  cluster_name = aws_eks_cluster.eks[each.key].name
  addon_name   = "vpc-cni"
}
