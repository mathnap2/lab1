output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Elastic IP associated with the instance."
  value       = aws_eip.this.public_ip
}

output "public_dns" {
  description = "AWS-assigned public DNS name of the instance."
  value       = aws_instance.this.public_dns
}

output "ami_id" {
  description = "AMI the instance was launched from."
  value       = data.aws_ami.al2023.id
}

output "ssh_allowed_cidr" {
  description = "CIDR permitted to reach SSH."
  value       = local.ssh_cidr
}

output "private_key_file" {
  description = "Path to the generated private key."
  value       = local_sensitive_file.private_key.filename
}

########################################
# DNS
########################################

output "route53_zone_id" {
  description = "Route 53 hosted zone ID."
  value       = aws_route53_zone.this.zone_id
}

output "route53_name_servers" {
  description = "Name servers for the hosted zone (delegation set)."
  value       = aws_route53_zone.this.name_servers
}

output "route53_fqdn" {
  description = "Fully qualified name of the A record in Route 53."
  value       = aws_route53_record.www.fqdn
}

output "sslip_hostname" {
  description = "Public hostname that resolves to the instance today (via sslip.io)."
  value       = "${var.dns_record_name}.${replace(aws_eip.this.public_ip, ".", "-")}.sslip.io"
}

output "web_url" {
  description = "URL of the web page served by the instance (resolvable now)."
  value       = "http://${var.dns_record_name}.${replace(aws_eip.this.public_ip, ".", "-")}.sslip.io"
}

output "web_url_ip" {
  description = "URL of the web page by raw IP."
  value       = "http://${aws_eip.this.public_ip}"
}

output "ssh_command" {
  description = "Ready-to-use SSH command."
  value       = "ssh -i ${local_sensitive_file.private_key.filename} ec2-user@${aws_eip.this.public_ip}"
}
