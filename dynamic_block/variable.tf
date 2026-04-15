variable "ingress_ports" {
    description = "this is segurity"
    type = list(number)
    default = [80,443,22]
}