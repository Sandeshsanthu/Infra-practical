variable "environment" {
    type = string
  
}
variable "regions" {
    type = map(object({
        cidr = string
        name = string
    }))

  
}