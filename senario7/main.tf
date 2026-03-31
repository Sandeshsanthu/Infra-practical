data "aws_db_instance" "existingdb" {
    db_instance_identifier = "database-1-instance-1"
    region = "eu-north-1"

  }

resource "aws_route53_record" "db_alias" {
    zone_id = "Z123456789"
    name    = "://example.com"
    type    = "CNAME"
    ttl     = "300"
    records = [data.aws_db_instance.existingdb.address]
  
}
