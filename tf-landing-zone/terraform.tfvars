###############################################################################
# Project Configurations
project_name    = "Sample"
region          = "us-east-1"
profile         = "Your Profile"
build_role      = "arn:aws:iam::<ACCOUNT_NUMBER>:role/sample-TF-Bootstrap-Rol"
apex_domain     = "sample.com"
alb_vpc         = "Network"
alb_subnet_name = "public"
alb_cidr_blocks = [
  "0.0.0.0/0"
]

###############################################################################
# DEV USAGE - REMOVE FOR PROD ENVS
disable_api_termination                 = false
force_destroy_s3                        = true
alb_external_enable_deletion_protection = false
alb_internal_enable_deletion_protection = false
rds_deletion_protection                 = false

###############################################################################
# VPC Configurations
vpcs = {
  Network = {
    vpc_cidr = "172.20.0.0/20"
    public_subnets = {
      a = {
        public = "172.20.1.0/24"
      },
      b = {
        public = "172.20.3.0/24"
      }
    }
    private_subnets = {
      a = {
        tgw = "172.20.0.0/28"
      },
      b = {
        tgw = "172.20.2.0/28"
      }
    }
    endpoint_s3         = true
    endpoint_ec2        = false
    endpoint_ssm        = false
    endpoint_ecr_api    = false
    endpoint_ecr_docker = false
    endpoint_logs       = false
    endpoint_sts        = false
    endpoint_subnet     = ""
  }
  Security = {
    vpc_cidr       = "172.20.16.0/20"
    public_subnets = {}
    private_subnets = {
      a = {
        tgw     = "172.20.16.0/28"
        private = "172.20.17.0/24"
        data    = "172.20.18.0/28"
      }
      b = {
        tgw     = "172.20.19.0/28"
        private = "172.20.20.0/24"
        data    = "172.20.21.0/28"
      }
    }
    endpoint_s3         = true
    endpoint_ec2        = false
    endpoint_ssm        = false
    endpoint_ecr_api    = false
    endpoint_ecr_docker = false
    endpoint_logs       = false
    endpoint_sts        = false
    endpoint_subnet     = ""
  }
  ManagedServices = {
    vpc_cidr       = "172.20.32.0/20"
    public_subnets = {}
    private_subnets = {
      a = {
        tgw     = "172.20.32.0/28"
        private = "172.20.33.0/24"
        data    = "172.20.34.0/28"
      },
      b = {
        tgw     = "172.20.35.0/28"
        private = "172.20.36.0/24"
        data    = "172.20.37.0/28"
      }
    }
    endpoint_s3         = true
    endpoint_ec2        = false
    endpoint_ssm        = false
    endpoint_ecr_api    = false
    endpoint_ecr_docker = false
    endpoint_logs       = false
    endpoint_sts        = false
    endpoint_subnet     = ""
  }
  EKS = {
    vpc_cidr       = "172.20.64.0/20"
    public_subnets = {}
    private_subnets = {
      a = {
        tgw         = "172.20.64.0/28"
        nodes       = "172.20.65.0/24"
        controllers = "172.20.66.0/28"
      },
      b = {
        tgw         = "172.20.67.0/28"
        nodes       = "172.20.68.0/24"
        controllers = "172.20.69.0/28"
      },
      c = {
        tgw         = "172.20.70.0/28"
        nodes       = "172.20.71.0/24"
        controllers = "172.20.72.0/28"
      },
    }
    endpoint_s3         = true
    endpoint_ec2        = true
    endpoint_ssm        = false
    endpoint_ecr_api    = true
    endpoint_ecr_docker = true
    endpoint_logs       = true
    endpoint_sts        = true
    endpoint_subnet     = "nodes"
  }
}

###############################################################################
# Server Configurations
ec2_servers = {
  Bastion = {
    ami_owner           = "309956199498"
    ami_name            = "RHEL-8.5.0_HVM-20211103-x86_64-0-Hourly2-GP2"
    instance_type       = "t3.xlarge"
    volume_size         = "20"
    vpc_name            = "Network"
    subnet_name         = "public"
    availability_zone   = "b"
    public_dns          = true
    private_dns         = true
    alb_access          = false
    alb_target_port     = ""
    alb_target_protocol = ""
    policy_names        = []
    s3_storage          = false
    user_data           = "setup_ssm_linux.tpl"
    ingress = {
      ssh = {
        description = "DNet Access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "167.219.0.140/32",
          "167.219.88.140/32",
        ]
      }
    }
  }
  vpn = {
    ami_owner           = "309956199498"
    ami_name            = "RHEL-8.5.0_HVM-20211103-x86_64-0-Hourly2-GP2"
    instance_type       = "m5.large"
    volume_size         = "20"
    vpc_name            = "Network"
    subnet_name         = "public"
    availability_zone   = "a"
    public_dns          = true
    private_dns         = true
    alb_access          = false
    alb_target_port     = ""
    alb_target_protocol = ""
    policy_names        = []
    s3_storage          = false
    user_data           = "setup_ssm_linux.tpl"
    ingress = {
      ssh = {
        description = "Internal address"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "167.219.0.140/32",
          "167.219.88.140/32",
        ]
      }
      https = {
        description = "vpn access"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [
          "0.0.0.0/0"
        ]
      }
    }
  }
  ipa = {
    ami_owner           = "309956199498"
    ami_name            = "RHEL-8.5.0_HVM-20211103-x86_64-0-Hourly2-GP2"
    instance_type       = "m5.xlarge"
    volume_size         = "100"
    vpc_name            = "ManagedServices"
    subnet_name         = "private"
    availability_zone   = "a"
    public_dns          = false
    private_dns         = true
    alb_access          = true
    alb_target_port     = "443"
    alb_target_protocol = "HTTPS"
    policy_names        = []
    s3_storage          = false
    user_data           = "setup_ssm_linux.tpl"
    ingress = {
      ssh = {
        description = "Internal address"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      http = {
        description = "HTTP from Internal address"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      https = {
        description = "HTTPS from Internal address"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      ldap = {
        description = "HTTPS from Internal address"
        from_port   = 389
        to_port     = 389
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      ldaps = {
        description = "HTTPS from Internal address"
        from_port   = 636
        to_port     = 636
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      kerberos_tcp = {
        description = "HTTPS from Internal address"
        from_port   = 88
        to_port     = 88
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      kerberos_88_udp = {
        description = "HTTPS from Internal address"
        from_port   = 88
        to_port     = 88
        protocol    = "udp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      kerberos_464_tcp = {
        description = "HTTPS from Internal address"
        from_port   = 464
        to_port     = 464
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      kerberos_464_udp = {
        description = "HTTPS from Internal address"
        from_port   = 464
        to_port     = 464
        protocol    = "udp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
    }
  }
  kubectl = {
    ami_owner           = "309956199498"
    ami_name            = "RHEL-8.5.0_HVM-20211103-x86_64-0-Hourly2-GP2"
    instance_type       = "t3.xlarge"
    volume_size         = "20"
    vpc_name            = "ManagedServices"
    subnet_name         = "private"
    availability_zone   = "a"
    public_dns          = false
    private_dns         = true
    alb_access          = false
    alb_target_port     = ""
    alb_target_protocol = ""
    policy_names        = []
    s3_storage          = false
    user_data           = "setup_ssm_linux.tpl"
    ingress = {
      ssh = {
        description = "Internal adderss"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
    }
  }
  gitlab = {
    ami_owner           = "309956199498"
    ami_name            = "RHEL-8.5.0_HVM-20211103-x86_64-0-Hourly2-GP2"
    instance_type       = "m5.xlarge"
    volume_size         = "500"
    vpc_name            = "ManagedServices"
    subnet_name         = "private"
    availability_zone   = "b"
    public_dns          = false
    private_dns         = true
    alb_access          = false
    alb_target_port     = ""
    alb_target_protocol = ""
    policy_names        = []
    s3_storage          = false
    user_data           = "setup_ssm_linux.tpl"
    ingress = {
      ssh = {
        description = "Internal address"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      http = {
        description = "HTTP from Internal address"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      https = {
        description = "HTTPS from Internal address"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
    }
  }
  gitlab-runner = {
    ami_owner           = "amazon"
    ami_name            = "amzn2-ami-kernel-5.10-hvm-2.0.20220218.3-x86_64-gp2"
    instance_type       = "m5.2xlarge"
    volume_size         = "100"
    vpc_name            = "ManagedServices"
    subnet_name         = "private"
    availability_zone   = "b"
    public_dns          = false
    private_dns         = true
    alb_access          = false
    alb_target_port     = ""
    alb_target_protocol = ""
    policy_names        = []
    s3_storage          = true
    user_data           = "setup_ssm_linux.tpl"
    ingress = {
      ssh = {
        description = "Internal address"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
    }
  }
  sonarqube = {
    ami_owner           = "309956199498"
    ami_name            = "RHEL-8.5.0_HVM-20211103-x86_64-0-Hourly2-GP2"
    instance_type       = "m5.xlarge"
    volume_size         = "20"
    vpc_name            = "ManagedServices"
    subnet_name         = "private"
    availability_zone   = "b"
    public_dns          = false
    private_dns         = true
    alb_access          = false
    alb_target_port     = ""
    alb_target_protocol = ""
    policy_names        = []
    s3_storage          = false
    user_data           = "setup_ssm_linux.tpl"
    ingress = {
      ssh = {
        description = "Internal address"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      http = {
        description = "Internal address"
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      https = {
        description = "Internal address"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
    }
  }
  nexus = {
    ami_owner           = "309956199498"
    ami_name            = "RHEL-8.5.0_HVM-20211103-x86_64-0-Hourly2-GP2"
    instance_type       = "m5.xlarge"
    volume_size         = "500"
    vpc_name            = "ManagedServices"
    subnet_name         = "private"
    availability_zone   = "b"
    public_dns          = false
    private_dns         = true
    alb_access          = false
    alb_target_port     = ""
    alb_target_protocol = ""
    policy_names        = []
    s3_storage          = false
    user_data           = "setup_ssm_linux.tpl"
    ingress = {
      ssh = {
        description = "Internal address"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      http = {
        description = "Internal address"
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      https = {
        description = "Internal address"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      docker_port = {
        description = "HTTPS from Internal address"
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
    }
  }
  elk = {
    ami_owner           = "309956199498"
    ami_name            = "RHEL-8.5.0_HVM-20211103-x86_64-0-Hourly2-GP2"
    instance_type       = "m5.xlarge"
    volume_size         = "100"
    vpc_name            = "Security"
    subnet_name         = "private"
    availability_zone   = "a"
    public_dns          = false
    private_dns         = true
    alb_access          = false
    alb_target_port     = ""
    alb_target_protocol = ""
    policy_names        = []
    s3_storage          = false
    user_data           = "setup_ssm_linux.tpl"
    ingress = {
      ssh = {
        description = "Internal address"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      ui = {
        description = "Internal address"
        from_port   = 5601
        to_port     = 5601
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
    }
  }
  vault = {
    ami_owner           = "309956199498"
    ami_name            = "RHEL-8.5.0_HVM-20211103-x86_64-0-Hourly2-GP2"
    instance_type       = "m5.large"
    volume_size         = "100"
    vpc_name            = "Security"
    subnet_name         = "private"
    availability_zone   = "a"
    public_dns          = false
    private_dns         = true
    alb_access          = false
    alb_target_port     = ""
    alb_target_protocol = ""
    policy_names        = ["Project_Name-KMS-Vault-Pol"] # Replace 'Project_Name'
    s3_storage          = false
    user_data           = "setup_ssm_linux.tpl"
    ingress = {
      ssh = {
        description = "Internal address"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      ui = {
        description = "Internal address"
        from_port   = 8200
        to_port     = 8200
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      https = {
        description = "Internal address"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
    }
  }
  openscap = {
    ami_owner           = "309956199498"
    ami_name            = "RHEL-8.5.0_HVM-20211103-x86_64-0-Hourly2-GP2"
    instance_type       = "t3.large"
    volume_size         = "50"
    vpc_name            = "Security"
    subnet_name         = "private"
    availability_zone   = "b"
    public_dns          = false
    private_dns         = true
    alb_access          = false
    alb_target_port     = ""
    alb_target_protocol = ""
    policy_names        = []
    s3_storage          = false
    user_data           = "setup_ssm_linux.tpl"
    ingress = {
      ssh = {
        description = "Internal address"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      http = {
        description = "Internal address"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
      https = {
        description = "Internal address"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/16"
        ]
      }
    }
  }
}

###############################################################################
# Database Configurations
rds_postgres_single_node = {
  managedservicesdb = {
    engine_version          = "13.3"
    instance_class          = "db.t3.large"
    username                = "MainUser"
    allocated_storage       = 50
    max_allocated_storage   = 500
    vpc_name                = "ManagedServices"
    subnet_name             = "data"
    availability_zone       = "b"
    subnet_group            = ["a", "b"]
    monitoring_interval     = 0
    backup_retention_period = 7
    ingress = {
      postgres = {
        description = "Managed Services VPC"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.32.0/20"
        ]
      }
      pgadmin = {
        description = "Network VPC"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.0.0/20"
        ]
      }
    }
  }
}

###############################################################################
# Initial Configuration Public Key
ec2_public_key = "Public Pem Key Value"

eks_public_key = "Public Pem Key Value"

###############################################################################
# EKS Configurations
eks_clusters = {
  dev = {
    version           = "1.21"
    vpc_name          = "EKS"
    controller_subnet = "controllers"
    node_subnet       = "nodes"
    elb_type          = "internal-elb"
    instance_type     = "m5.xlarge"
    disk_size         = 100
    node_desired_size = 2
    node_max_size     = 5
    node_min_size     = 1
    kubectl_cidr      = ["172.20.64.0/20"]
    user_data         = ""
    s3_storage        = true
    oidc_fingerprints = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
    ingress = {
      ssh = {
        description = "SSH Access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.64.0/20",
        ]
      }
      http = {
        description = "http"
        from_port   = 30100
        to_port     = 30100
        protocol    = "tcp"
        cidr_blocks = [
          "172.20.64.0/20",
        ]
      }
    }
  }
}
