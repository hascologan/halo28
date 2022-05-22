###############################################################################
# Add Route to Private DNS
resource "aws_route53_record" "rds_postgres_single_node" {
  for_each = var.rds_postgres_single_node

  zone_id = aws_route53_zone.private.zone_id
  name    = lower("${each.key}.${var.apex_domain}")
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.rds_postgres_single_node[each.key].address]
}
