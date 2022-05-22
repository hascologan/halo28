###############################################################################
# Add Route to Public DNS
resource "aws_route53_record" "public" {
  for_each = {
    for name, values in var.ec2_servers : name => values
    if values.public_dns
  }

  zone_id = data.aws_route53_zone.public.zone_id
  name    = lower("${each.key}.${var.apex_domain}")
  type    = "A"
  ttl     = "300"
  records = [aws_eip.ec2[each.key].public_ip]
}
