terraform {
  required_providers {
    aws = {
        source = "value"
        version = "value"
    }
  }

}
provider "aws" {
    region = "us-east-1"
  
}