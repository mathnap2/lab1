########################################
# DNS  (Amazon Route 53)
########################################
#
# AWS Academy Learner Lab does not allow registering a real domain, so this
# public hosted zone is not delegated from a registrar. It still shows how
# DNS is managed as code with Terraform: a hosted zone plus records that
# resolve the instance by name inside Route 53.
#
# For a name that resolves from anywhere today (screenshots / grading), the
# `web_url` output uses sslip.io, a free wildcard DNS service that maps
# <ip>.sslip.io -> <ip>.

resource "aws_route53_zone" "this" {
  name    = var.dns_zone_name
  comment = "Managed by Terraform - ${var.project_name}"

  tags = {
    Name = "${var.project_name}-zone"
  }
}

# A record: www.<zone>  ->  Elastic IP of the instance
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "${var.dns_record_name}.${var.dns_zone_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.this.public_ip]
}

# Apex record: <zone> -> same Elastic IP
resource "aws_route53_record" "apex" {
  zone_id = aws_route53_zone.this.zone_id
  name    = var.dns_zone_name
  type    = "A"
  ttl     = 300
  records = [aws_eip.this.public_ip]
}
