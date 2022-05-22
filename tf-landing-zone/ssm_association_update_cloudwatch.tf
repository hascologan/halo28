resource "aws_ssm_association" "update_cloudwatch" {
  association_name = "${var.project_name}_Update_Cloudwatch_Agents"
  name             = "AWS-ConfigureAWSPackage"

  schedule_expression = "cron(0 2 ? * SUN *)"
  compliance_severity = "HIGH"

  targets {
    key    = "InstanceIds"
    values = ["*"]
  }

  parameters = {
    "action" = "Install",
    "name"   = "AmazonCloudWatchAgent"
  }
}
