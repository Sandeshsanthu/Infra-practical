terraform {
   required_providers {
     aws = {
        source  = "hashicorp/aws"
        version = "6.41.0"
     }
   }
    

  }

  provider "aws" {
    alias = "us_prod"
    region = "us-east-1"
    
  }

  provider "aws" {
    alias = "eu_prod"
    region = "eu-central-1"
    
  }
