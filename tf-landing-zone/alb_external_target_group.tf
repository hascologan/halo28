###############################################################################
# Create Target Group
resource "aws_lb_target_group" "alb" {
  for_each = {
    for key, value in var.ec2_servers : key => value
    if value.alb_access
  }

  name        = substr(replace("${var.project_name}-${var.alb_vpc}-${each.key}-TGr", " ", ""), 0, 32)
  port        = each.value.alb_target_port
  protocol    = each.value.alb_target_protocol
  target_type = "ip"
  vpc_id      = aws_vpc.vpc[var.alb_vpc].id

  # health_check {
  #   path                = each.value.health_check_path
  #   protocol            = each.value.target_protocol
  #   healthy_threshold   = "5"
  #   unhealthy_threshold = "2"
  # }

  tags = {
    Name = replace("${var.project_name}-${var.alb_vpc}-${each.key}-TGr", " ", "")
  }
}

resource "aws_lb_target_group_attachment" "alb" {
  for_each = {
    for key, value in var.ec2_servers : key => value
    if value.alb_access
  }

  target_group_arn  = aws_lb_target_group.alb[each.key].arn
  target_id         = aws_instance.ec2[each.key].private_ip
  port              = each.value.alb_target_port
  availability_zone = "all"
}
