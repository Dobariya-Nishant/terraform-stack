# =============================
# 📦 Core VPC Module Input Vars
# =============================

variable "project_name" {
  description = "The name of the project this infrastructure is associated with. Used for naming and tagging resources."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod). Helps differentiate resources across environments."
  type        = string
}

variable "region" {
  description = "Region in which resources are provisioned"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Region in which resources are provisioned"
  type        = string
}

