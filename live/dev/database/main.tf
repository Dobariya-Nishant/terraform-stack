locals {
  subnets = data.terraform_remote_state.network.outputs.subnets
  sg      = data.terraform_remote_state.network.outputs.sg
}

module "docdb" {
  source          = "../../../modules/docdb"
  name            = "backend"
  project_name    = var.project_name
  environment     = var.environment
  username        = var.project_name
  password        = var.environment
  subnet_ids      = local.subnets["docdb"]
  security_groups = [local.sg["docdb"]]
}
