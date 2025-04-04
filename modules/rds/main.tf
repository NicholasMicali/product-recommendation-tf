locals {
  monitoring_role_arn = var.create_monitoring_role ? aws_iam_role.enhanced_monitoring[0].arn : var.monitoring_role_arn
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.final_snapshot_identifier_prefix}-${var.identifier}-${try(random_id.snapshot_identifier[0].hex, "")}"
}

resource "aws_db_instance" "this" {
  identifier = var.identifier
  engine     = "postgres"
  engine_version = "15.3"
  instance_class = "db.t3.large"
  allocated_storage = 100
  storage_type = "gp3"
  
  db_name  = var.db_name
  username = var.username
  manage_master_user_password = true

  multi_az = true
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name = var.db_subnet_group_name

  backup_retention_period = 7
  backup_window = "03:00-04:00"
  maintenance_window = "Mon:04:00-Mon:05:00"

  storage_encrypted = true
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = local.final_snapshot_identifier

  performance_insights_enabled = true
  performance_insights_retention_period = 7

  monitoring_interval = 60
  monitoring_role_arn = local.monitoring_role_arn

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = var.tags
}

resource "aws_iam_role" "enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0

  name               = "rds-enhanced-monitoring-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0

  role       = aws_iam_role.enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
