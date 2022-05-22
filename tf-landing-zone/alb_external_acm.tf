###############################################################################
# Create ACM Certificate
resource "aws_acm_certificate" "alb" {
  domain_name               = var.apex_domain
  subject_alternative_names = ["*.${var.apex_domain}"]
  validation_method         = "DNS"

  tags = {
    Name = replace("${var.project_name}-ALB-ACM", " ", "")
  }

  lifecycle {
    create_before_destroy = true
  }
}

###############################################################################
# Create Domain Validation Record
resource "aws_route53_record" "alb" {
  for_each = {
    for dvo in aws_acm_certificate.alb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public.zone_id
}

###############################################################################
# Validate ACM Certificate
resource "aws_acm_certificate_validation" "alb" {
  certificate_arn         = aws_acm_certificate.alb.arn
  validation_record_fqdns = [for record in aws_route53_record.alb : record.fqdn]
}
