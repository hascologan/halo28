###############################################################################
# Find The Public Route 53 Hosted Zone
data "aws_route53_zone" "public" {
  name         = var.apex_domain
  private_zone = false
}
