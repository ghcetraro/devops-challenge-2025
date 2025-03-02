#
resource "aws_cloudwatch_log_group" "cluster" {
  name = var.cluster.name
}
#
resource "aws_cloudwatch_log_group" "log_group_dev" {
  for_each          = var.services
  name              = lookup(each.value, "name", each.key)
  retention_in_days = var.cluster.cloudwatch_retention
  tags              = local.tags
}
#