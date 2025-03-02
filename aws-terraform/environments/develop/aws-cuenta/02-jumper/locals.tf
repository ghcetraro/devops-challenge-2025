locals {
  app_name_dashed = "${var.account}-${var.environment}"
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
  #
  account_id = data.aws_caller_identity.current.account_id
  #
  ssh_key_name = data.terraform_remote_state.ssh.outputs.private_key_name
}