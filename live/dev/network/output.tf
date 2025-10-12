output "vpc_id" {
  description = "VPC, subnets, and security groups combined"
  value       = module.vpc.id
}

output "subnets" {
  description = "All subnet IDs grouped by type"
  value = {
    public   = module.vpc.public_sub_ids
    private  = module.vpc.private_sub_ids
    asg      = module.vpc.asg_sub_ids
    frontend = module.vpc.frontend_sub_ids
    backend  = module.vpc.backend_sub_ids
    docdb    = module.vpc.database_sub_ids
  }
}

output "sg" {
  description = "All security group IDs grouped by purpose"
  value = {
    frontend_alb = module.vpc.frontend_alb_sg_id
    backend_alb  = module.vpc.backend_alb_sg_id
    frontend     = module.vpc.frontend_sg_id
    backend      = module.vpc.backend_sg_id
    docdb        = module.vpc.docdb_sg_id
    bastion_ec2  = module.vpc.bastion_ec2_sg_id
    asg          = module.vpc.asg_sg_id
    jenkins      = module.vpc.jenkins_sg_id
    jenkins_efs  = module.vpc.jenkins_efs_sg_id
  }
}

output "route53" {
  description = "All security group IDs grouped by purpose"
  value = {
    zone_id         = module.route53.zone_id
    domain_name     = module.route53.domain_name
    certificate_arn = module.route53.certificate_arn
  }
}
