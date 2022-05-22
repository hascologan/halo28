###############################################################################
# EC2 Elastic IP
resource "aws_eip" "ec2" {
  for_each = {
    for server, config in var.ec2_servers : server => config
    if config.subnet_name == "public"
  }

  instance = aws_instance.ec2[each.key].id
  vpc      = true

  tags = {
    Name = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-EIP", " ", "")
  }
}
