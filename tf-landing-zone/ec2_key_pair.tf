###############################################################################
# EC2 Key Pair
resource "aws_key_pair" "ec2" {
  key_name   = replace("${var.project_name}-KPr", " ", "")
  public_key = var.ec2_public_key

  tags = {
    Name = replace("${var.project_name}-KPr", " ", "")
  }
}
