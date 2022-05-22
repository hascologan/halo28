###############################################################################
# EKS Key Pair
resource "aws_key_pair" "eks" {
  key_name   = replace("${var.project_name}-EKS-KPr", " ", "")
  public_key = var.eks_public_key

  tags = {
    Name = replace("${var.project_name}-EKS-KPr", " ", "")
  }
}
