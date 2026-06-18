variable "environments" {
  type = map(object({
    environment_name = string
    vpcs = map(object({
      vpc_cidr = string
      subnets = list(object({
        name = string
        tier = string # e.g., "public", "private", "database"
        cidr = string
      }))
    }))
  }))
  description = "Nested map containing environment, VPC, and subnet specifications."
  default = {
    "prod" = {
      environment_name = "production"
      vpcs = {
        "primary" = {
          vpc_cidr = "10.0.0.0/16"
          subnets = [
            { name = "pub-1a", tier = "public",  cidr = "10.0.1.0/24" },
            { name = "pub-1b", tier = "public",  cidr = "10.0.2.0/24" },
            { name = "app-1a", tier = "private", cidr = "10.0.11.0/24" },
            { name = "app-1b", tier = "private", cidr = "10.0.12.0/24" }
          ]
        },
        "secondary" = {
          vpc_cidr = "10.1.0.0/16"
          subnets = [
            { name = "dmz-1a", tier = "public",  cidr = "10.1.1.0/24" },
            { name = "app-1a", tier = "private", cidr = "10.1.11.0/24" }
          ]
        }
      }
    }
  }

  validation {
    condition     = alltrue([for env in var.environments : alltrue([for vpc in env.vpcs : can(cidrnetmask(vpc.vpc_cidr))])])
    error_message = "All VPC CIDR blocks must be valid IPv4 notations."
  }
}
