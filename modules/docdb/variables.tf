#################################
# Core Configuration
#################################

variable "project_name" {
  description = "Name of the overall project. Used for consistent naming and tagging across all resources."
  type        = string
}

variable "name" {
  description = "Base name prefix for the DocumentDB cluster and related resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)."
  type        = string
}

variable "username" {
  description = "Master username for the DocumentDB cluster."
  type        = string
}

variable "password" {
  description = "Master password for the DocumentDB cluster."
  type        = string
  sensitive   = true
}

#################################
# Networking
#################################

variable "subnet_ids" {
  description = <<EOT
List of subnet IDs for the DocumentDB subnet group.
To ensure high availability, specify subnets from at least two different Availability Zones.
EOT
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs to associate with the cluster."
  type        = list(string)
}

#################################
# Instance Configuration
#################################

variable "instance_class" {
  description = "Instance class for each DocumentDB instance (e.g., db.r6g.large)."
  type        = string
  default     = "db.t3.medium"
}

variable "instance_count" {
  description = "Number of instances to create in the cluster (>=2 recommended for HA)."
  type        = number
  default     = 1
}

#################################
# Cluster Options
#################################

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot before deleting the cluster (true for dev/test only)."
  type        = bool
  default     = true
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrades of the DocumentDB cluster."
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Whether to apply modifications immediately or during the maintenance window."
  type        = bool
  default     = false
}

#################################
# Security & Encryption
#################################

variable "storage_encrypted" {
  description = "Enable storage encryption for the DocumentDB cluster."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "KMS Key ID for encrypting the cluster storage. Use null for the AWS-managed key."
  type        = string
  default     = null
}

#################################
# Backup & Maintenance
#################################

variable "backup_retention_period" {
  description = "Number of days to retain automated backups (1-35)."
  type        = number
  default     = null
}

variable "preferred_backup_window" {
  description = "Preferred daily backup window in UTC (e.g., 03:00-06:00)."
  type        = string
  default     = null
}

variable "preferred_maintenance_window" {
  description = "Weekly maintenance window in UTC (e.g., sun:05:00-sun:06:00)."
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Protect the cluster from accidental deletion."
  type        = bool
  default     = true
}

#################################
# Logging & Monitoring
#################################

variable "enabled_cloudwatch_logs_exports" {
  description = "Log types to export to CloudWatch Logs. Supported: audit, profiler."
  type        = list(string)
  default     = ["audit", "profiler"]
}

#################################
# Parameter Group
#################################

variable "parameter_overrides" {
  description = "Custom cluster parameter overrides (e.g., TLS, connection limits)."
  type        = map(string)
  default = {
    tls = "enabled"
  }
}
