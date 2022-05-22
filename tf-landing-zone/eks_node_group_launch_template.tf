###############################################################################
# EKS Node Group Lanch Template
resource "aws_launch_template" "eks" {
  for_each = var.eks_clusters

  # image_id = "" # This will be defined when custom ami are build
  name                    = "${each.key}-eks-launch-template"
  update_default_version  = true
  description             = "This is a launch template for the EKS Nodes for ${each.key} cluster"
  disable_api_termination = var.disable_api_termination
  instance_type           = each.value.instance_type
  key_name                = aws_key_pair.eks.key_name
  user_data               = each.value.user_data == "" ? null : templatefile("./${each.value.user_data}", { region = data.aws_region.current.name })
  vpc_security_group_ids  = [aws_security_group.eks_node_group[each.key].id]

  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = each.value.disk_size
      volume_type           = "gp2"
      # tags = {
      #   Name = replace("${var.project_name}-${each.key}-EBS", " ", "")
      # }
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = replace("${var.project_name}-${each.key}-EC2", " ", "")
    }
  }

  tags = {
    Name = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-EC2", " ", "")
  }
}
