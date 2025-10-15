
output "route53" {
  description = "All security group IDs grouped by purpose"
  value = {
    zone_id         = module.route53.zone_id
    domain_name     = module.route53.domain_name
    certificate_arn = module.route53.certificate_arn
  }
}

output "ci_cd_role_arn" {
  value = module.iam.ci_cd_role_arn
}