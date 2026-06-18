output "production_subnet_plan" {
  value = {
    for key, config in aws_subnet.flattened_subnets : key => {
      arn  = config.arn
      cidr = config.cidr_block
    }
  }
  description = "A mapping of the created subnet resource addresses and details."
}
