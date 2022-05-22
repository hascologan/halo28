###############################################################################
# Configure Terraform
terraform {
  required_version = "1.1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.14.0"
    }
  }
}

###############################################################################
# Configure the AWS Provider
provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      resource-created-by = "terraform"
    }
  }

  #---------------------------------------------#
  # Required for Deloitte OneCloud Environments #
  ignore_tags {
    keys = [
      "LastScanned",
      "BILLINGCODE",
      "BILLINGCONTACT",
      "COUNTRY",
      "CSCLASS",
      "CSQUAL",
      "CSTYPE",
      "ENVIRONMENT",
      "FUNCTION",
      "MEMBERFIRM",
      "PRIMARYCONTACT",
      "SECONDARYCONTACT",
      "cpm backup"
    ]
  }
  #---------------------------------------------#
}

# Get account information
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}
