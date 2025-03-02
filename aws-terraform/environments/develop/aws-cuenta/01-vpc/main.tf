#
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "${var.project}-${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway                 = true
  enable_vpn_gateway                 = false
  propagate_private_route_tables_vgw = true
  propagate_public_route_tables_vgw  = true
  manage_default_route_table         = true

  tags = local.tags
}