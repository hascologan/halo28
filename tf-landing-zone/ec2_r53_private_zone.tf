###############################################################################
# Add Route to Private DNS
resource "aws_route53_record" "private" {
  for_each = {
    for name, values in var.ec2_servers : name => values
    if values.private_dns
  }

  zone_id = aws_route53_zone.private.zone_id
  name    = lower("${each.key}.${var.apex_domain}")
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ec2[each.key].private_ip]
}
