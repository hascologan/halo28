resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_lb.external.arn
  web_acl_arn  = aws_wafv2_web_acl.alb.arn
}
