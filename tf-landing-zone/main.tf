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
  backend "s3" {
    region         = "us-east-1"
    profile        = "Your Profile"
    dynamodb_table = "<DynamoDB Table Name>"
    bucket         = "<S3 Bucket Name>"

    # Do not change the name below
    key = "tf-landing-zone.tfstate"
  }
}

###############################################################################
# Configure the AWS Provider(s)
provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      resource-created-by = "terraform"
    }
  }
  assume_role {
    role_arn = var.build_role
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
      "NETWORK",
      "Config",
      "cpm backup"
    ]
  }
  #---------------------------------------------#
}

# Get account information
data "aws_canonical_user_id" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}
