# Instance for USA
module "network_us" {
  source      = "./modules/networking"
  env         = var.environment
  region_name = var.regions["us"].name
  cidr_block  = var.regions["us"].cidr

  providers = {
    aws = aws.us_prod
  }
}

# Instance for EUROPE
module "network_eu" {
  source      = "./modules/networking"
  env         = var.environment
  region_name = var.regions["eu"].name
  cidr_block  = var.regions["eu"].cidr

  providers = {
    aws = aws.eu_prod
  }
}
