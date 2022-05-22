###############################################################################
# IAM Instance Profile
resource "aws_iam_instance_profile" "tf_bootstrap" {
  name = replace("${var.project_name}-TF-Bootstrap-IPr", " ", "")
  role = aws_iam_role.tf_bootstrap.name
}

###############################################################################
# IAM Role
resource "aws_iam_role" "tf_bootstrap" {
  name        = replace("${var.project_name}-TF-Bootstrap-Rol", " ", "")
  description = "Role for ${var.project_name} Terraform Bootstraping"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
            AWS     = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
          }
        }
      ]
    }
  )

  managed_policy_arns = [
    aws_iam_policy.tf_state_lock_pol.arn
  ]

  tags = {
    Name = replace("${var.project_name}-TF-Bootstrap-Rol", " ", "")
  }
}

###############################################################################
# IAM Role Inline Policy
resource "aws_iam_role_policy" "tf_bootstrap" {
  name = replace("${var.project_name}-TF-Bootstrap-Pol", " ", "")
  role = aws_iam_role.tf_bootstrap.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
