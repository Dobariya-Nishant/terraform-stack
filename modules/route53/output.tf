output "zone_id" {
  value       = local.zone_id
  description = "Hosted zone ID used for records."
}

output "domain_name" {
  value       = var.domain_name
  description = "Domain name of Hosted zone."
}

output "certificate_arn" {
  value       = aws_acm_certificate_validation.this.certificate_arn
  description = "ARN of the validated ACM certificate."
}

output "record_fqdns" {
  value       = { for k, v in aws_route53_record.records : k => v.fqdn }
  description = "Fully qualified domain names for regular records."
}

output "alias_fqdns" {
  value       = { for k, v in aws_route53_record.alias_records : k => v.fqdn }
  description = "Fully qualified domain names for alias records."
}
