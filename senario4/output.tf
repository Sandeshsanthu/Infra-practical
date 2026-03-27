output "eip_public_ip" {
    description = "all is good"
    value = one(aws_eip.myip[*].public_ip)

}