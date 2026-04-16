output "alb_dns_name" {
  value = aws_alb.web_alb.dns_name
  description = "Access the application here"
}