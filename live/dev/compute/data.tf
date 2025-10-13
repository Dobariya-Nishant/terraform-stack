data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "activatree-terraform"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "activatree-terraform"
    key    = "global/terraform.tfstate"
    region = "us-east-1"
  }
}