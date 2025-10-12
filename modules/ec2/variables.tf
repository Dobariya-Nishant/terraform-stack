# ==========================
# Core Project Configuration
# ==========================

variable "project_name" {
  description = "Name of the overall project. Used for consistent naming and tagging across all resources."
  type        = string
}

variable "name" {
  description = "Base name used as an identifier for all resources (e.g., key name, launch template name, etc.)."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod). Used for tagging and naming consistency."
  type        = string
}

# ==========
# Networking
# ==========

variable "subnet_id" {
  description = "List of subnet IDs for the Auto Scaling Group to launch instances in. Determines availability zones."
  type        = string
}

variable "security_groups" {
  description = "List of security groups IDs for bestion ec2"
  type        = list(string)
}

# =======================
# EC2 & AMI Configuration
# =======================

variable "instance_type" {
  description = "EC2 instance type to launch (e.g., t3.micro, m5.large)."
  type        = string
  default     = "t3.micro"
}

variable "ebs_type" {
  description = "EBS volume type (e.g., gp2, gp3, io1) attached to EC2 instances."
  type        = string
  default     = "gp2"
}

variable "ebs_size" {
  description = "Size (in GB) of the root EBS volume attached to EC2 instances."
  type        = string
  default     = 30
}