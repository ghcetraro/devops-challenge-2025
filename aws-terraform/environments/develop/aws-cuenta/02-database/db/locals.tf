#
locals {
  #
  aws_profile = var.account
  #
  tags = {
    project     = var.project
    environment = var.environment
    created_by  = "terraform"
    code_repo   = "devops-challenge-2025"
    region      = var.region
  }
}