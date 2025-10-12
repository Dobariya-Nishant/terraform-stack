module "vpc" {
  source             = "../../../modules/vpc"
  project_name       = var.project_name
  environment        = var.environment
  cidr_block         = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  frontend_subnets   = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  backend_subnets    = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
  database_subnets   = ["10.0.40.0/24", "10.0.41.0/24", "10.0.42.0/24"]
  asg_subnets        = ["10.0.50.0/24", "10.0.51.0/24", "10.0.52.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  enable_nat_gateway = true
}

module "route53" {
  source      = "../../../modules/route53"
  domain_name = "dev.activatree.com"
}

