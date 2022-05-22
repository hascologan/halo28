###############################################################################
# EC2 Instance
resource "aws_instance" "ec2" {
  for_each = var.ec2_servers

  ami                     = data.aws_ami.ec2[each.key].id
  disable_api_termination = var.disable_api_termination
  iam_instance_profile    = aws_iam_instance_profile.ec2[each.key].id
  instance_type           = each.value.instance_type
  monitoring              = true
  vpc_security_group_ids  = [aws_security_group.ec2[each.key].id]
  subnet_id               = each.value.subnet_name == "public" ? aws_subnet.public["${each.value.vpc_name}.${each.value.subnet_name}.${each.value.availability_zone}"].id : aws_subnet.private["${each.value.vpc_name}.${each.value.subnet_name}.${each.value.availability_zone}"].id
  key_name                = aws_key_pair.ec2.key_name
  source_dest_check       = each.key == "Bastion" ? false : true
  user_data               = each.value.user_data == "" ? null : templatefile("./${each.value.user_data}", { region = data.aws_region.current.name })

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = each.value.volume_size
    volume_type           = "gp2"
    tags = {
      Name = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-EBS", " ", "")
    }
  }

  tags = {
    Name = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-EC2", " ", "")
  }

  #---------------------------------------------#
  # Required for Deloitte OneCloud Environments #
  lifecycle {
    ignore_changes = [root_block_device[0].tags]
  }
  #---------------------------------------------#
}
