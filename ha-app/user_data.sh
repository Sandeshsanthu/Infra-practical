#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
TOKEN=$(curl -X PUT "http://169.254.169" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169)
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169)

echo "<h1>Highly Available Web App</h1><p>Running on Instance: <b>$INSTANCE_ID</b> in Zone: <b>$AZ</b></p>" > /var/www/html/index.html
