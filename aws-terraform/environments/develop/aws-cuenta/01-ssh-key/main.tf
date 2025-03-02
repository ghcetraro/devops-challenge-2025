#
module "ssh_key" {
  source = "../../../../modules/ssh_key/v1"
  tags   = local.tags
}