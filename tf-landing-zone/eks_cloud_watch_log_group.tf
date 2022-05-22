resource "aws_cloudwatch_log_group" "eks" {
  for_each = var.eks_clusters

  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name       = "/aws/eks/${lower(each.key)}/cluster"
  kms_key_id = aws_kms_key.cwlogs_kms.arn

  tags = {
    Name = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-CWL", " ", "")
  }
}
