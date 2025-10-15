variable "project_name" {
  description = "Map of key-value pairs representing secrets (like your .env)"
  type        = string
}

variable "environment" {
  description = "Map of key-value pairs representing secrets (like your .env)"
  type        = string
}

variable "prefix" {
  description = "Map of key-value pairs representing secrets (like your .env)"
  type        = string
}

variable "secrets" {
  description = "Map of key-value pairs representing secrets (like your .env)"
  type        = map(string)
  # sensitive   = true
}
