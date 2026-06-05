variable "app_name" {
    type = string
    description = "The name of the application service (lowercase, alphanumeric, and hyphens)."
    validation {
      condition     = can(regex("^[a-z0-9-]+$", var.app_name))
      error_message = "The app_name must be lowercase, alphanumeric, and co"
      
      
    }
}

variable "environment" {
    type        = string
    description = "The deployment stage target."
    validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be one of: dev, stage, prod."
  }
}

variable "tier" {
  type        = string
  description = "The performance tier matching resource demands."

  validation {
    condition     = contains(["light", "standard", "enterprise"], var.tier)
    error_message = "Tier must be one of: light, standard, enterprise."
  }
}
  

  
