#
data "aws_secretsmanager_secret" "current" {
  name = var.cluster.name
}
#
data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.current.id
}