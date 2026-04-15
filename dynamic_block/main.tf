resource "aws_security_group" "my-sg" {
    name = "dynamic-sg"

    dynamic "ingress" {
        for_each = var.ingress_ports
        content {
          from_port = ingress.value
          to_port = ingress.value
          protocol = "tcp"
          cidr_blocks = [ "0.0.0.0/0" ]
        }
      
    }
}