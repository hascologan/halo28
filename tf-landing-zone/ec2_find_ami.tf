###############################################################################
# Find the lastest AMI Image
data "aws_ami" "ec2" {
  for_each = var.ec2_servers

  most_recent = true
  owners      = [each.value.ami_owner]

  filter {
    name   = "name"
    values = [each.value.ami_name]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
