###############################################################################
# EKS Controller IAM Role
resource "aws_iam_role" "eks_oidc" {
  for_each = var.eks_clusters

  name        = replace("${var.project_name}-${each.key}-OIDC-Rol", " ", "")
  description = "Role for ${var.project_name} ${each.key} EKS OIDC Cluster"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity"
          Effect = "Allow"
          Principal = {
            Federated = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${trimprefix(aws_eks_cluster.eks[each.key].identity[0].oidc[0].issuer, "https://")}"
          }
          Condition = {
            StringEquals = {
              "${trimprefix(aws_eks_cluster.eks[each.key].identity[0].oidc[0].issuer, "https://")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
            }
          }
        }
      ]
    }
  )

  inline_policy {
    name   = "AWSLoadBalancerControllerIAMPolicy"
    policy = templatefile("./eks_cluster_oidc_policy.tpl", { partion = data.aws_partition.current.partition })
  }

  tags = {
    Name = replace("${var.project_name}-${each.key}-OIDC-Rol", " ", "")
  }

  #---------------------------------------------#
  # Required for Deloitte OneCloud Environments #
  lifecycle {
    ignore_changes = [
      permissions_boundary
    ]
  }
  #---------------------------------------------#
}
