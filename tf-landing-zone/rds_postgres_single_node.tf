###############################################################################
# RDS PostgreSQL Deployment - Single AZ
resource "aws_db_instance" "rds_postgres_single_node" {
  for_each = var.rds_postgres_single_node

  engine                    = "postgres"
  multi_az                  = false
  engine_version            = each.value.engine_version
  instance_class            = each.value.instance_class
  identifier                = each.key
  username                  = each.value.username
  password                  = var.master_db_password
  allocated_storage         = each.value.allocated_storage
  max_allocated_storage     = each.value.max_allocated_storage
  availability_zone         = join("", [data.aws_region.current.name, each.value.availability_zone])
  db_subnet_group_name      = aws_db_subnet_group.rds_postgres_single_node[each.key].id
  vpc_security_group_ids    = [aws_security_group.rds_postgres_single_node[each.key].id]
  backup_retention_period   = each.value.backup_retention_period
  monitoring_interval       = each.value.monitoring_interval
  storage_encrypted         = true
  kms_key_id                = aws_kms_key.rds_kms.arn
  copy_tags_to_snapshot     = true
  deletion_protection       = var.rds_deletion_protection
  final_snapshot_identifier = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-RDS-final", " ", "")

  tags = {
    Name = replace("${var.project_name}-${each.value.vpc_name}-${each.key}-RDS", " ", "")
  }

  #---------------------------------------------#
  # Required for Deloitte OneCloud Environments #
  lifecycle {
    ignore_changes = [latest_restorable_time]
  }
  #---------------------------------------------#
}
