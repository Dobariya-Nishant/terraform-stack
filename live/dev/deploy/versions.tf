terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "cardstudio-terraform-state-bucket"
    key            = "stag/deploy/terraform.tfstate"
    dynamodb_table = "tf-backend-lock"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
    }
  }
}