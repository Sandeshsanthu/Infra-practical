# Active Health Check on the Primary Public IP
resource "aws_route53_health_check" "primary" {
  provider          = aws.primary
  ip_address        = aws_instance.primary_server.public_ip
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "2"   # Fail fast for interview purposes
  request_interval  = "10"  # Checked every 10 seconds

  tags = { Name = "demo-primary-health-check" }
}

# Primary Failover Record
resource "aws_route53_record" "primary" {
  provider = aws.primary
  zone_id  = data.aws_route53_zone.main.zone_id
  name     = "failover-demo.${var.domain_name}"
  type     = "A"
  ttl      = "10" # Aggressive low TTL so browsers do not cache the stale record

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier  = "primary-active"
  health_check_id = aws_route53_health_check.primary.id
  records         = [aws_instance.primary_server.public_ip]
}

# Secondary Failover Record
resource "aws_route53_record" "secondary" {
  provider = aws.primary
  zone_id  = data.aws_route53_zone.main.zone_id
  name     = "failover-demo.${var.domain_name}"
  type     = "A"
  ttl      = "10"

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "secondary-passive"
  records        = [aws_instance.secondary_server.public_ip]
}

output "demo_url" {
  value       = "http://failover-demo.${var.domain_name}"
  description = "The URL to visit and test your live failover demo"
}
