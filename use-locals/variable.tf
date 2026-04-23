variable "region" {
    description = "the region"
    type = string
    default = "us-east-1"
  
}

variable "environment" {
    type = string
    description = "Deployment environment (dev, stg, prd)"
    validation {
      condition = contains(["dev","stg","prd"], var.environment)
      error_message = "environment must be valid"
    }
  
}

variable "app_name" {
    type = string
    default = "payment"
  
}