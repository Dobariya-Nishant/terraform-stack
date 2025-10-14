locals {
  route53 = data.terraform_remote_state.global.outputs.route53
  vpc_id  = data.terraform_remote_state.network.outputs.vpc_id
  subnets = data.terraform_remote_state.network.outputs.subnets
  sg      = data.terraform_remote_state.network.outputs.sg
}

module "frontend_alb" {
  source              = "../../../modules/alb"
  name                = "frontend"
  project_name        = var.project_name
  environment         = var.environment
  subnet_ids          = local.subnets["public"]
  security_groups     = [local.sg["frontend_alb"]]
  domain_names        = [local.route53.domain_name, "api.${local.route53.domain_name}"]
  vpc_id              = local.vpc_id
  hostedzone_id       = local.route53.zone_id
  acm_certificate_arn = local.route53.certificate_arn
  target_groups = {
    jenkins = {
      name              = "jenkins"
      port              = 8080
      protocol          = "HTTP"
      target_type       = "ip"
      health_check_path = "/login"
    }
    web = {
      name              = "web"
      port              = 80
      protocol          = "HTTP"
      target_type       = "ip"
      health_check_path = "/"
    }
    api = {
      name              = "api"
      port              = 80
      protocol          = "HTTP"
      target_type       = "ip"
      health_check_path = "/api/health"
    }
  }
  listener = {
    name             = "frontend"
    target_group_key = "web"
    rules = {
      jenkins_rule = {
        description      = "Jenkins path routing"
        target_group_key = "jenkins"
        hosts            = ["jenkins.${local.route53.domain_name}"]
      }
      api_rule = {
        description      = "Jenkins path routing"
        target_group_key = "api"
        hosts            = ["api.${local.route53.domain_name}"]
      }
    }
  }
}

module "jenkins_asg" {
  source           = "../../../modules/asg"
  name             = "jenkins"
  project_name     = var.project_name
  environment      = var.environment
  subnet_ids       = local.subnets["asg"]
  security_groups  = [local.sg["asg"]]
  ecs_cluster_name = var.ecs_cluster_name
  desired_capacity = 0
  max_size         = 0
  min_size         = 0
}

module "frontend_asg" {
  source           = "../../../modules/asg"
  name             = "frontend"
  project_name     = var.project_name
  environment      = var.environment
  subnet_ids       = local.subnets["asg"]
  security_groups  = [local.sg["asg"]]
  ecs_cluster_name = var.ecs_cluster_name
  desired_capacity = 1
  max_size         = 2
  min_size         = 0
}

module "backend_asg" {
  source           = "../../../modules/asg"
  name             = "backend"
  project_name     = var.project_name
  environment      = var.environment
  subnet_ids       = local.subnets["asg"]
  security_groups  = [local.sg["asg"]]
  ecs_cluster_name = var.ecs_cluster_name
  desired_capacity = 1
  max_size         = 2
  min_size         = 0
}

# module "bastion_ec2" {
#   source          = "../../../modules/ec2"
#   name            = "bastion"
#   project_name    = var.project_name
#   environment     = var.environment
#   subnet_id       = local.subnets["public"][0]
#   security_groups = [local.sg["bastion_ec2"]]
# }


