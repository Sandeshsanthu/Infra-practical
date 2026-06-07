terraform {
    required_version = ">= 1.5.0"
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
}

provider "aws" {
    alias = "primary"
    region = var.primary_region
  
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

data "aws_route53_zone" "main" {
  provider = aws.primary
  name     = var.domain_name
}