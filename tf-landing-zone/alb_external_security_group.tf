###############################################################################
# ALB Security Group
resource "aws_security_group" "alb" {
  name        = replace("${var.project_name}-${var.alb_vpc}-ALB-ScG", " ", "")
  description = "Security group for ALB"
  vpc_id      = aws_vpc.vpc[var.alb_vpc].id

  ingress {
    description = "http ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_cidr_blocks
  }

  ingress {
    description = "https ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.alb_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = replace("${var.project_name}-${var.alb_vpc}-ALB-ScG", " ", "")
  }
}
