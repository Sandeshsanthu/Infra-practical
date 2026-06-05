module "my_app_infra" {
  source = "./.."

  app_name    = "payment-api"
  environment = "dev"
  tier        = "light"
}
