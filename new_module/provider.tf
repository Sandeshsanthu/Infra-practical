terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "6.38.0"
    }
  }
}

provider "aws" {
    region = "eu-north-1"
  
}