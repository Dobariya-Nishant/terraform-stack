data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "cardstudio-terraform-state-bucket"
    key    = "stag/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"
  config = {
    bucket = "cardstudio-terraform-state-bucket"
    key    = "stag/compute/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "storage" {
  backend = "s3"
  config = {
    bucket = "cardstudio-terraform-state-bucket"
    key    = "stag/storage/terraform.tfstate"
    region = "us-east-1"
  }
}