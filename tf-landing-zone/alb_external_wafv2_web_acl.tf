resource "aws_wafv2_web_acl" "alb" {
  name  = replace("${var.project_name}-${var.alb_vpc}-WAc", " ", "")
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "default_rule_group"
    priority = 1

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.alb.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "default-rule-group-acl"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "managed-bad-rep-ip"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "bad-rep-ip-block"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "managed-anon-ip"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "anon-ip-block"
      sampled_requests_enabled   = true
    }
  }

  # Rule for rate limiting inbound connections.
  rule {
    name     = "rate-limit-inbound"
    priority = 10

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "alb_waf_acl"
    sampled_requests_enabled   = true
  }
}
