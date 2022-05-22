###############################################################################
# EKS Controller IAM Role
resource "aws_iam_role" "eks_controller" {
  for_each = var.eks_clusters

  name        = replace("${var.project_name}-${each.key}-Rol", " ", "")
  description = "Role for ${var.project_name} ${each.key} EKS Cluster"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "eks.amazonaws.com"
          }
        }
      ]
    }
  )

  tags = {
    Name = replace("${var.project_name}-${each.key}-Rol", " ", "")
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

resource "aws_iam_role_policy_attachment" "eks_controller_AmazonEKSClusterPolicy" {
  for_each = var.eks_clusters

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_controller[each.key].name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks_controller_AmazonEKSVPCResourceController" {
  for_each = var.eks_clusters

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_controller[each.key].name
}
