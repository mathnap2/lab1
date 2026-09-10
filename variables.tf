variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Named AWS CLI profile to use for credentials."
  type        = string
  default     = "academy"
}

variable "project_name" {
  description = "Name prefix applied to created resources and tags."
  type        = string
  default     = "lab1"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "root_volume_size" {
  description = "Size (GiB) of the root EBS volume."
  type        = number
  default     = 8
}

variable "http_ingress_cidr" {
  description = "CIDR block allowed to reach the web server (port 80)."
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_ingress_cidr" {
  description = <<-EOT
    CIDR block allowed to reach SSH (port 22). Leave empty to auto-detect
    your current public IP (recommended). Set to "0.0.0.0/0" to allow all
    (not recommended).
  EOT
  type        = string
  default     = ""
}

variable "dns_zone_name" {
  description = <<-EOT
    Domain name for the Route 53 public hosted zone created by this config
    (e.g. "dse-lab1.example"). AWS Academy Learner Lab does not let you
    register a real domain, so this zone is not delegated from a registrar;
    it demonstrates managing DNS with Terraform. A ready-to-resolve URL is
    also produced via sslip.io (see the `web_url` output).
  EOT
  type        = string
  default     = "dse-lab1-745671.com"
}

variable "dns_record_name" {
  description = "Hostname (relative to dns_zone_name) for the A record pointing at the instance."
  type        = string
  default     = "www"
}
