# Fetch pre-existing core networking owned by the Platform Team
data "aws_vpc" "shared" {
  tags = { Environment = var.environment }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.shared.id]
  }
  tags = { Type = "Private" }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.shared.id]
  }
  tags = { Type = "Public" }
}

# 1-3. KMS Cryptographic Security Keys
resource "aws_kms_key" "app_storage" {
  description             = "Encryption key for ${var.app_name}-${var.environment}"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags                    = local.common_tags
}
resource "aws_kms_alias" "app_storage" {
  name          = "alias/${var.app_name}-${var.environment}-key"
  target_key_id = aws_kms_key.app_storage.key_id
}

# 4-6. IAM App Policies & Instance Profiles
resource "aws_iam_role" "app_role" {
  name = "${var.app_name}-${var.environment}-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "://amazonaws.com" } }]
  })
  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.app_name}-${var.environment}-profile"
  role = aws_iam_role.app_role.name
}

# 7-9. Network Access Firewalls (Security Groups)
resource "aws_security_group" "lb" {
  name        = "${var.app_name}-${var.environment}-lb-sg"
  vpc_id      = data.aws_vpc.shared.id
  tags        = local.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "lb_http" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_security_group" "app" {
  name        = "${var.app_name}-${var.environment}-app-sg"
  vpc_id      = data.aws_vpc.shared.id
  tags        = local.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "app_from_lb" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.lb.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_security_group" "db" {
  name        = "${var.app_name}-${var.environment}-db-sg"
  vpc_id      = data.aws_vpc.shared.id
  tags        = local.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

# 10-12. Application Load Balancing Infrastructure
resource "aws_lb" "external" {
  name               = "${var.app_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = data.aws_subnets.public.ids
  tags               = local.common_tags
}

resource "aws_lb_target_group" "app" {
  name     = "${var.app_name}-${var.environment}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.shared.id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.external.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# 13-14. Auto Scaling & Compute Fleet Infrastructure
resource "aws_launch_template" "app" {
  name_prefix   = "${var.app_name}-${var.environment}-lt-"
  image_id      = "ami-0c55b159cbfafe1f0" # Golden Production Linux AMI
  instance_type = local.cfg.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.app_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp3"
      encrypted   = true
      kms_key_id  = aws_kms_key.app_storage.arn
    }
  }
  tags = local.common_tags
}

resource "aws_autoscaling_group" "app" {
  name                = "${var.app_name}-${var.environment}-asg"
  vpc_zone_identifier = data.aws_subnets.private.ids
  target_group_arns   = [aws_lb_target_group.app.arn]
  min_size            = local.cfg.min_capacity
  max_size            = local.cfg.max_capacity
  desired_capacity    = local.cfg.min_capacity

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}

# 15-17. Production Database Subnet & Instances
resource "aws_db_subnet_group" "db" {
  name       = "${var.app_name}-${var.environment}-db-subnet"
  subnet_ids = data.aws_subnets.private.ids
  tags       = local.common_tags
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.app_name}-${var.environment}-db"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = local.cfg.db_class
  db_name                = replace(var.app_name, "-", "")
  username               = "app_admin"
  password               = "SuperSecretProductionPassword123!" # In real prod, read from AWS Secrets Manager
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db.id]
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.app_storage.arn
  skip_final_snapshot    = var.environment == "prod" ? false : true
  backup_retention_period = local.cfg.backup_retention
  tags                   = local.common_tags
}

# 18-20. Production Performance Dashboards & Monitoring Logs
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/app/${var.app_name}-${var.environment}"
  retention_in_days = var.environment == "prod" ? 90 : 14
  tags              = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.app_name}-${var.environment}-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Scale down execution alert for ${var.app_name} on high cluster load."
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.app_name}-${var.environment}-metrics"
  dashboard_body = jsonencode({
    widgets = [{
      type   = "metric"
      x      = 0
      y      = 0
      width  = 12
      height = 6
      properties = {
        metrics = [["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.external.arn_suffix]]
        period  = 300
        stat    = "Sum"
        region  = "us-east-1"
        title   = "${var.app_name} Total Requests Received"
      }
    }]
  })
}
