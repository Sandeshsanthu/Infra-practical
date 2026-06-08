terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "prod-company-tfstate-bucket"
    key            = "prod/applications/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# Zero-cost dynamic link to the networking layer state file
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "prod-company-tfstate-bucket"
    key    = "prod/networking/terraform.tfstate"
    region = "us-east-1"
  }
}
