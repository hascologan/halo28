###############################################################################
# EKS Node Group IAM Role
resource "aws_iam_role" "eks_node_group" {
  for_each = var.eks_clusters

  name        = replace("${var.project_name}-${each.key}-Node-Group-Rol", " ", "")
  description = "Role for ${var.project_name} ${each.key} EKS Node Group"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
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

resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonSSMManagedInstanceCore" {
  for_each = var.eks_clusters

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node_group[each.key].name
}

resource "aws_iam_role_policy_attachment" "eks_node_group_CloudWatchAgentServerPolicy" {
  for_each = var.eks_clusters

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_node_group[each.key].name
}

resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEKSWorkerNodePolicy" {
  for_each = var.eks_clusters

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group[each.key].name
}

resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEKS_CNI_Policy" {
  for_each = var.eks_clusters

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group[each.key].name
}

resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEC2ContainerRegistryReadOnly" {
  for_each = var.eks_clusters

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group[each.key].name
}
