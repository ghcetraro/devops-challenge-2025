#
module "databases" {
  source = "../../../../../modules/database/engine/v1"
  #
  region      = var.region
  environment = var.environment
  project     = var.project
  #
  vpc     = var.vpc
  cluster = var.cluster
  #
  tags = local.tags
}