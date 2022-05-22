###############################################################################
# Set Default Encyption Key
resource "aws_ebs_default_kms_key" "ebs_default_key" {
  key_arn = aws_kms_key.ebs_kms.arn
}

#--------------------------------------------------#
# Commented Out For Deloitte OneCloud Environments #
###############################################################################
# Enable EBS Encryption By Default
# resource "aws_ebs_encryption_by_default" "ebs_encryption" {
#   enabled = true
# }
#--------------------------------------------------#
