###############################################################################
# EKS OpenID (OIDC)
resource "aws_iam_openid_connect_provider" "eks" {
  for_each = var.eks_clusters

  url = aws_eks_cluster.eks[each.key].identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = each.value.oidc_fingerprints

  tags = {
    Name = replace("${var.project_name}-${each.key}-OIDC", " ", "")
  }
}
