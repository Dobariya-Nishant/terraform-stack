###################################
# Core Domain and Zone
###################################
variable "domain_name" {
  description = "Root domain (e.g., example.com)."
  type        = string
}

variable "create_zone" {
  description = "Create a new Route53 hosted zone?"
  type        = bool
  default     = true
}

variable "existing_zone_id" {
  description = "Use this existing hosted zone instead of creating one."
  type        = string
  default     = null
}

###################################
# Certificate
###################################
variable "include_root_domain" {
  description = "Include the root domain in ACM SAN."
  type        = bool
  default     = true
}

###################################
# Normal DNS Records
###################################
variable "records" {
  description = <<EOT
Map of regular DNS records.
Example:
{
  "www" = {
    type    = "CNAME"
    ttl     = 300
    records = ["example.com"]
  }
  "api" = {
    type    = "A"
    ttl     = 300
    records = ["1.2.3.4"]
  }
}
EOT
  type = map(object({
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = {}
}

###################################
# Alias Records (LoadBalancer/CloudFront)
###################################
variable "aliases" {
  description = <<EOT
Map of alias records.
Example:
{
  "app" = {
    type                   = "A"
    alias_name             = aws_lb.app.dns_name
    alias_zone_id          = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}
EOT
  type = map(object({
    type                   = string
    alias_name             = string
    alias_zone_id          = string
    evaluate_target_health = bool
  }))
  default = {}
}

###################################
# Tags
###################################
variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
