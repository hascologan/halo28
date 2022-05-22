###############################################################################
# Create Map of Private Subnets
locals {
  private_subnets = flatten([
    for vpc_name, vpc_config in var.vpcs : [
      for az, subnets in vpc_config.private_subnets : [
        for subnet_name, subnet_cidr in subnets : {
          vpc_name          = vpc_name
          availability_zone = az
          subnet_name       = subnet_name
          subnet_cidr       = subnet_cidr
        }
      ]
    ]
  ])
}

###############################################################################
# Create Set of VPCs with Private Subnets Only
locals {
  has_private_subnets_only = toset(
    compact(
      flatten([
        for vpc_name, vpc_config in var.vpcs : length(vpc_config.public_subnets) == 0 ? vpc_name : ""
      ])
    )
  )
}

###############################################################################
# Create Map of Public Subnets
locals {
  public_subnets = flatten([
    for vpc_name, vpc_config in var.vpcs : [
      for az, subnets in vpc_config.public_subnets : [
        for subnet_name, subnet_cidr in subnets : {
          vpc_name          = vpc_name
          availability_zone = az
          subnet_name       = subnet_name
          subnet_cidr       = subnet_cidr
        }
      ]
    ]
  ])
}

###############################################################################
# Create Set of VPCs with Public Subnets
locals {
  has_public_subnets = toset(
    flatten([
      for vpc_name, vpc_config in var.vpcs : [
        for az, subnets in vpc_config.public_subnets : [
          vpc_name
        ]
      ]
    ])
  )
}

###############################################################################
# Create Map of VPC(s) with Public Subnets that Point to Private Only VPC(s)
locals {
  public_to_private_routes = flatten([
    for public_vpc in local.has_public_subnets : [
      for private_vpc in local.has_private_subnets_only : {
        public_vpc = public_vpc
        route      = aws_vpc.vpc[private_vpc].cidr_block
      }
    ]
  ])
}
