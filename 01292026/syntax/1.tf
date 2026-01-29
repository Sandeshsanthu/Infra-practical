variable "users" {
  type = list(object({
    name = string
    age  = number
  }))
echo users[*]
}
