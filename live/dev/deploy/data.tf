data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "activatree-terraform"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"
  config = {
    bucket = "activatree-terraform"
    key    = "dev/compute/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "storage" {
  backend = "s3"
  config = {
    bucket = "activatree-terraform"
    key    = "dev/storage/terraform.tfstate"
    region = "us-east-1"
  }
}