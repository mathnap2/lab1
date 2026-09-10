aws_region    = "us-east-1"
aws_profile   = "academy"
project_name  = "lab1"
instance_type = "t2.micro"

# Leave empty to auto-lock SSH to your current public IP.
# Or set explicitly, e.g. "203.0.113.4/32" or "0.0.0.0/0".
ssh_ingress_cidr = ""

# Route 53 hosted zone created by Terraform (not delegated in Learner Lab).
dns_zone_name   = "dse-lab1-745671.com"
dns_record_name = "www"
