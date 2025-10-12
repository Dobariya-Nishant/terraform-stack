locals {
  subnets = data.terraform_remote_state.network.outputs.subnets
  sg      = data.terraform_remote_state.network.outputs.sg
}

module "jenkins_efs" {
  source          = "../../../modules/efs"
  name            = "jenkins"
  project_name    = var.project_name
  environment     = var.environment
  subnet_ids      = local.subnets["private"]
  security_groups = [local.sg["jenkins_efs"]]
  access_points = {
    jenkins = "/jenkins"
  }
}

module "frontend" {
  source       = "../../../modules/ecr"
  name         = "frontend"
  project_name = var.project_name
  environment  = var.environment
}

module "backend" {
  source       = "../../../modules/ecr"
  name         = "backend"
  project_name = var.project_name
  environment  = var.environment
}
