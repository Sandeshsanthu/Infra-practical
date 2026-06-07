variable "domain_name" {
    type = string
    description = "Your registered Route53 domain name (e.g., yourcompany.com)"
  
}

variable "primary_region" {
    type    = string
    default = "us-east-1"
  
}

variable "secondary_region" {
    type    = string
    default = "us-west-2" 
  
}