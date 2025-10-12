data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "cardstudio-terraform-state-bucket"
    key    = "stag/network/terraform.tfstate"
    region = "us-east-1"
  }
}