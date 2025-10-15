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

variable "backend_secrets" {
  description = "Map of key-value pairs representing secrets (like your .env)"
  type        = map(string)
  # sensitive   = true
}

