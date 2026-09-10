provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project      = var.project_name
      ManagedBy    = "terraform"
      StudentId    = var.student_id
      StudentEmail = var.student_email
    }
  }
}
