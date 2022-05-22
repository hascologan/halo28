###############################################################################
# Listener on 443
resource "aws_lb_listener" "alb_https" {
  load_balancer_arn = aws_lb.external.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.alb.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "You have found the end of the internet"
      status_code  = "200"
    }
  }
}
