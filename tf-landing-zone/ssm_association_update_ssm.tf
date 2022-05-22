resource "aws_ssm_association" "update_ssm" {
  association_name = "${var.project_name}_Update_SSM_Agents"
  name             = "AWS-UpdateSSMAgent"

  schedule_expression = "cron(0 2 ? * SUN *)"
  compliance_severity = "HIGH"

  targets {
    key    = "InstanceIds"
    values = ["*"]
  }
}
