###############################################################################
# Add Route to Public DNS
resource "aws_route53_record" "alb_targets" {
  for_each = {
    for key, value in var.ec2_servers : key => value
    if value.alb_access
  }

  zone_id = data.aws_route53_zone.public.zone_id
  name    = lower("${each.key}.${var.apex_domain}")
  type    = "A"

  alias {
    name                   = aws_lb.external.dns_name
    zone_id                = aws_lb.external.zone_id
    evaluate_target_health = true
  }
}
