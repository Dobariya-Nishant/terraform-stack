
module "route53" {
  source      = "../../modules/route53"
  domain_name = "dev.activatree.com"
}

module "iam" {
  source = "../../modules/iam"
  name = "github_actions"
  github_org = "Dobariya-Nishant"
  github_repos = ["actree","actree-client"]
}

