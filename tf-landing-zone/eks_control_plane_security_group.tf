###############################################################################
# Security Group
resource "aws_security_group" "eks_control_plane" {
  for_each = var.eks_clusters

  name        = replace("${var.project_name}-${each.key}-EKS-Control-Plane-ScG", " ", "")
  description = "EKS Security group for ${each.key} control plane"
  vpc_id      = aws_vpc.vpc[each.value.vpc_name].id

  ingress {
    description = "kubectl server"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = each.value.kubectl_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = replace("${var.project_name}-${each.key}-EKS-Control-Plane-ScG", " ", "")
  }
}
