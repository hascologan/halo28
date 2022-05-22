###############################################################################
# Variables Required
variable "project_name" {
  description = "Unique alias for project related resources."
  type        = string
}

variable "region" {
  description = "AWS region. Required: explicit or sourced here or from the AWS_DEFAULT_REGION environment variable."
  type        = string
}

variable "profile" {
  description = "This is the AWS profile name as set in the shared credentials file."
  type        = string
}

variable "build_role" {
  description = "This is the AWS role that will be assumed during deployment."
  type        = string
}

variable "apex_domain" {
  description = "A registered domain name used for record creation."
  type        = string
}

variable "alb_vpc" {
  description = "The VPC ID where the ALB is to resides."
  type        = string
}

variable "alb_subnet_name" {
  description = "The Subnet ID where the ALB is to reside."
  type        = string
}

variable "alb_cidr_blocks" {
  description = "List of CIDR blocks."
  type        = list(any)
}

variable "vpcs" {
  description = "A configurable map of VPC settings."
  type        = map(any)
}

variable "ec2_servers" {
  description = "A configurable map of EC2 settings."
  type        = map(any)
}

variable "rds_postgres_single_node" {
  description = "A configurable map of RDS settings."
  type        = map(any)
}

variable "master_db_password" {
  description = "An admin DB password."
  type        = string
  sensitive   = true
}

variable "ec2_public_key" {
  description = "The public key material for service nodes."
  type        = string
  sensitive   = true
}

variable "eks_public_key" {
  description = "The public key material for EKS nodes."
  type        = string
  sensitive   = true
}

variable "eks_clusters" {
  description = "A configurable map of EKS settings."
  type        = map(any)
}

###############################################################################
# Variables With Default Values
variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. Default is default, which makes your instances shared on the host."
  type        = string
  default     = "default"
}

variable "force_destroy_s3" {
  description = "A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error."
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection."
  type        = bool
  default     = true
}

variable "alb_external_enable_deletion_protection" {
  description = "If true, deletion of the external load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer."
  type        = bool
  default     = true
}

variable "alb_internal_enable_deletion_protection" {
  description = "If true, deletion of the internal load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer."
  type        = bool
  default     = true
}

variable "rds_deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true."
  type        = bool
  default     = true
}

variable "expire_s3_objs" {
  description = "Specifies lifecycle rule status."
  type        = string
  default     = "Enabled"
}

variable "s3_objs_expire_days" {
  description = "Specifies a period in the object's expire."
  type        = number
  default     = 7
}
