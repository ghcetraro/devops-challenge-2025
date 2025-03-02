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
  time = var.cluster.tag
  #
  account_id = data.aws_caller_identity.current.account_id
  #
  ecr_reg = "${local.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  #
  image_public = "${local.ecr_reg}/${var.cluster.name}:${var.cluster.tag}"
  #
  path_public = "${path.module}/docker-images"
  #
  src_sha256_public = sha256(join("", [for f in fileset(".", "${local.path_public}/**") : file(f)]))
  #
  dkr_login_cmd = <<-EOT
    aws --profile ${local.aws_profile} ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${local.ecr_reg}
    EOT
}
#