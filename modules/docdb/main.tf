resource "aws_docdb_cluster_parameter_group" "this" {
  family = "docdb5.0"
  name   = "${var.name}-db-params-${var.environment}"

  parameter {
    name  = "tls"
    value = "enabled"
  }
}

resource "aws_docdb_subnet_group" "this" {
  name       = "${var.name}-db-group-${var.environment}"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-db-group-${var.environment}"
  }
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier              = "${var.name}-db-cluster-${var.environment}"
  engine                          = "docdb"
  master_username                 = var.username
  master_password                 = var.password
  db_subnet_group_name            = aws_docdb_subnet_group.this.name
  vpc_security_group_ids          = var.security_groups
  skip_final_snapshot             = var.skip_final_snapshot
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = var.kms_key_id
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this.name
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  deletion_protection             = true
  allow_major_version_upgrade     = true
  enabled_cloudwatch_logs_exports = ["audit", "profiler"]

  tags = {
    Name = "${var.name}-db-cluster-${var.environment}"
  }
}

resource "aws_docdb_cluster_instance" "this" {
  count = var.instance_count

  identifier                 = "${var.name}-db-${var.environment}-${count.index}"
  cluster_identifier         = aws_docdb_cluster.this.id
  instance_class             = var.instance_class
  auto_minor_version_upgrade = true

  tags = {
    Name = "${var.name}-db-${var.environment}-${count.index}"
  }
}
