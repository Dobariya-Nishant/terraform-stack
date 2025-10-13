locals {
  subnets = data.terraform_remote_state.network.outputs.subnets
  sg      = data.terraform_remote_state.network.outputs.sg
}

module "docdb" {
  source          = "../../../modules/docdb"
  name            = "backend"
  project_name    = var.project_name
  environment     = var.environment
  username        = "activatree_admin"
  password        = "activatree_admin"
  subnet_ids      = local.subnets["docdb"]
  security_groups = [local.sg["docdb"]]
}
