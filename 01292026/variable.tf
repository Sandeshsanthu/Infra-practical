variable "allowed_ports"{

    description = "TCP ports"
    type = list(number)
    default = [22,443]

validation {
    condition = alltrue([for p in var.allowed_ports : p >=1 && p<=65535])
    error_message = "ällow ports are allowed"
}
}
