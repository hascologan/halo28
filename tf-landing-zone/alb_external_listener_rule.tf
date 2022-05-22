###############################################################################
# ALB Listener Rule
resource "aws_lb_listener_rule" "alb" {
  for_each = {
    for key, value in var.ec2_servers : key => value
    if value.alb_access
  }

  listener_arn = aws_lb_listener.alb_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb[each.key].arn
  }

  condition {
    host_header {
      values = [lower("${each.key}.${var.apex_domain}")]
    }
  }

}
