#
resource "aws_ecr_repository" "app_ecr_repo" {
  for_each     = var.services
  name         = lookup(each.value, "name", each.key)
  tags         = local.tags
  force_delete = true
}