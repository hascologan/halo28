###############################################################################
# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2" {
  for_each = var.ec2_servers

  name = replace("${var.project_name}-${each.key}-IPr", " ", "")
  role = aws_iam_role.ec2[each.key].name
}

###############################################################################
# IAM Policy
resource "aws_iam_role" "ec2" {
  for_each = var.ec2_servers

  depends_on = [aws_iam_policy.kms_vault_pol]

  name        = replace("${var.project_name}-${each.key}-Rol", " ", "")
  description = "Role for ${var.project_name} ${each.key} EC2"

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

  managed_policy_arns = concat(
    ["arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"],
    [for policy in each.value.policy_names : "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/${policy}"]
  )

  tags = {
    Name = replace("${var.project_name}-${each.key}-Rol", " ", "")
  }

  #---------------------------------------------#
  # Required for Deloitte OneCloud Environments #
  lifecycle {
    ignore_changes = [
      permissions_boundary,
      managed_policy_arns
    ]
  }
  #---------------------------------------------#
}
