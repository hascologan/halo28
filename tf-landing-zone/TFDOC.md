# TF-Landing-Zone Resource Index

<!-- prettier-ignore-start -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.alb](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.alb](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudtrail.enable](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.eks](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.rds_postgres_single_node](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.rds_postgres_single_node](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/db_subnet_group) | resource |
| [aws_default_route_table.main](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/default_route_table) | resource |
| [aws_ebs_default_kms_key.ebs_default_key](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/ebs_default_kms_key) | resource |
| [aws_ec2_transit_gateway.tgw](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_route.tgw_to_hub](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.tgw](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.ec2](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/eip) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/eip) | resource |
| [aws_eks_addon.cni](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.eks](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/eks_node_group) | resource |
| [aws_flow_log.vpc](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/flow_log) | resource |
| [aws_iam_instance_profile.ec2](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_openid_connect_provider.eks](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.kms_vault_pol](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.ec2](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_controller](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_oidc](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ec2_s3b](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.eks_s3b](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.eks_controller_AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_controller_AmazonEKSVPCResourceController](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_node_group_AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_node_group_AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_node_group_AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_node_group_AmazonSSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_node_group_CloudWatchAgentServerPolicy](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.ec2](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/instance) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/internet_gateway) | resource |
| [aws_key_pair.ec2](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/key_pair) | resource |
| [aws_key_pair.eks](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/key_pair) | resource |
| [aws_kms_alias.cwlogs_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_alias) | resource |
| [aws_kms_alias.ebs_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_alias) | resource |
| [aws_kms_alias.eks_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_alias) | resource |
| [aws_kms_alias.s3_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_alias) | resource |
| [aws_kms_alias.vault_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.cwlogs_kms](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_key) | resource |
| [aws_kms_key.ebs_kms](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_key) | resource |
| [aws_kms_key.eks_kms](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_kms](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_key) | resource |
| [aws_kms_key.s3_kms](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_key) | resource |
| [aws_kms_key.vault_kms](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/kms_key) | resource |
| [aws_launch_template.eks](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/launch_template) | resource |
| [aws_lb.external](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/lb) | resource |
| [aws_lb_listener.alb_http](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.alb_https](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.alb](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.alb](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.alb](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/lb_target_group_attachment) | resource |
| [aws_nat_gateway.ngw](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/nat_gateway) | resource |
| [aws_route.igw](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route) | resource |
| [aws_route.ngw](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route) | resource |
| [aws_route.tgw](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route) | resource |
| [aws_route.tgw_hub_to_spoke](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route) | resource |
| [aws_route53_record.alb](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route53_record) | resource |
| [aws_route53_record.alb_targets](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route53_record) | resource |
| [aws_route53_record.private](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route53_record) | resource |
| [aws_route53_record.public](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route53_record) | resource |
| [aws_route53_record.rds_postgres_single_node](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route53_record) | resource |
| [aws_route53_zone.private](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route53_zone) | resource |
| [aws_route53_zone_association.private](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route53_zone_association) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/route_table_association) | resource |
| [aws_s3_account_public_access_block.enable](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_account_public_access_block) | resource |
| [aws_s3_bucket.cloudtrail_s3b](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.ec2_s3b](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.eks_s3b](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3_alb_logs](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3_logs_s3b](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.vpc_flow_logs_s3b](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.s3_logs_s3b_acl](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.cloudtrail_s3b_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.s3_alb_logs_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.s3_logs_s3b_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.vpc_flow_logs_s3b_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.cloudtrail_s3b_logs](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_logging.ec2_s3b_logs](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_logging.eks_s3b_logs](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_logging.vpc_flow_logs_s3b_logs](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_policy.cloudtrail_s3b_policy](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.ec2_logs_s3b_policy](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.eks_logs_s3b_policy](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.lb_log_access](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.s3_logs_s3b_policy](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.vpc_flow_logs_s3b_policy](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.cloudtrail_s3b_encryption](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.ec2_s3b_encryption](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.eks_s3b_encryption](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_alb_logs_encryption](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_logs_s3b_encryption](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.vpc_flow_logs_s3b_encryption](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group) | resource |
| [aws_security_group.ec2](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group) | resource |
| [aws_security_group.eks_control_plane](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group) | resource |
| [aws_security_group.eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group) | resource |
| [aws_security_group.rds_postgres_single_node](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group) | resource |
| [aws_security_group.vpc_endpoints](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.eks_cluster_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.loopback_eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rds_postgres_single_node_egress](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rds_postgres_single_node_ingress](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group_rule) | resource |
| [aws_ssm_association.update_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/ssm_association) | resource |
| [aws_ssm_association.update_ssm](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/ssm_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.ec2](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ec2_messages](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_api](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_docker](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.logs](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssm](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssm_messages](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.sts](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/vpc_endpoint) | resource |
| [aws_wafv2_rule_group.alb](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/wafv2_rule_group) | resource |
| [aws_wafv2_web_acl.alb](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.alb](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/wafv2_web_acl_association) | resource |
| [aws_ami.ec2](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/caller_identity) | data source |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/canonical_user_id) | data source |
| [aws_ec2_transit_gateway_route_table.tgw](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/ec2_transit_gateway_route_table) | data source |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/elb_service_account) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/region) | data source |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/route53_zone) | data source |
| [aws_subnets.tgw](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_cidr_blocks"></a> [alb\_cidr\_blocks](#input\_alb\_cidr\_blocks) | List of CIDR blocks. | `list(any)` | n/a | yes |
| <a name="input_alb_external_enable_deletion_protection"></a> [alb\_external\_enable\_deletion\_protection](#input\_alb\_external\_enable\_deletion\_protection) | If true, deletion of the external load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. | `bool` | `true` | no |
| <a name="input_alb_internal_enable_deletion_protection"></a> [alb\_internal\_enable\_deletion\_protection](#input\_alb\_internal\_enable\_deletion\_protection) | If true, deletion of the internal load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. | `bool` | `true` | no |
| <a name="input_alb_subnet_name"></a> [alb\_subnet\_name](#input\_alb\_subnet\_name) | The Subnet ID where the ALB is to reside. | `string` | n/a | yes |
| <a name="input_alb_vpc"></a> [alb\_vpc](#input\_alb\_vpc) | The VPC ID where the ALB is to resides. | `string` | n/a | yes |
| <a name="input_apex_domain"></a> [apex\_domain](#input\_apex\_domain) | A registered domain name used for record creation. | `string` | n/a | yes |
| <a name="input_build_role"></a> [build\_role](#input\_build\_role) | This is the AWS role that will be assumed during deployment. | `string` | n/a | yes |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | If true, enables EC2 Instance Termination Protection. | `bool` | `true` | no |
| <a name="input_ec2_public_key"></a> [ec2\_public\_key](#input\_ec2\_public\_key) | The public key material for service nodes. | `string` | n/a | yes |
| <a name="input_ec2_servers"></a> [ec2\_servers](#input\_ec2\_servers) | A configurable map of EC2 settings. | `map(any)` | n/a | yes |
| <a name="input_eks_clusters"></a> [eks\_clusters](#input\_eks\_clusters) | A configurable map of EKS settings. | `map(any)` | n/a | yes |
| <a name="input_eks_public_key"></a> [eks\_public\_key](#input\_eks\_public\_key) | The public key material for EKS nodes. | `string` | n/a | yes |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | A boolean flag to enable/disable DNS hostnames in the VPC. | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | A boolean flag to enable/disable DNS support in the VPC. | `bool` | `true` | no |
| <a name="input_expire_s3_objs"></a> [expire\_s3\_objs](#input\_expire\_s3\_objs) | Specifies lifecycle rule status. | `string` | `"Enabled"` | no |
| <a name="input_force_destroy_s3"></a> [force\_destroy\_s3](#input\_force\_destroy\_s3) | A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. | `bool` | `false` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC. Default is default, which makes your instances shared on the host. | `string` | `"default"` | no |
| <a name="input_master_db_password"></a> [master\_db\_password](#input\_master\_db\_password) | An admin DB password. | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | This is the AWS profile name as set in the shared credentials file. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Unique alias for project related resources. | `string` | n/a | yes |
| <a name="input_rds_deletion_protection"></a> [rds\_deletion\_protection](#input\_rds\_deletion\_protection) | If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true. | `bool` | `true` | no |
| <a name="input_rds_postgres_single_node"></a> [rds\_postgres\_single\_node](#input\_rds\_postgres\_single\_node) | A configurable map of RDS settings. | `map(any)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region. Required: explicit or sourced here or from the AWS\_DEFAULT\_REGION environment variable. | `string` | n/a | yes |
| <a name="input_s3_objs_expire_days"></a> [s3\_objs\_expire\_days](#input\_s3\_objs\_expire\_days) | Specifies a period in the object's expire. | `number` | `7` | no |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | A configurable map of VPC settings. | `map(any)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- prettier-ignore-end -->
