#
resource "postgresql_role" "readonly" {
  name        = "readonly"
  search_path = []
}
#
resource "random_password" "internal_roles" {
  for_each = toset(var.databases)
  length   = 24
  special  = false # @ character could lead to issues in "postgresql" provider
}
#
resource "postgresql_role" "internal_roles" {
  for_each    = toset(var.databases)
  name        = each.key
  login       = true
  password    = random_password.internal_roles[each.key].result
  roles       = [postgresql_role.readonly.name]
  search_path = []
}
#
resource "postgresql_database" "db" {
  for_each          = toset(var.databases)
  name              = each.key
  owner             = postgresql_role.internal_roles[each.key].name
  connection_limit  = -1
  allow_connections = true
}
#
resource "local_file" "ssh_key" {
  for_each = toset(var.databases)
  content  = random_password.internal_roles[each.key].result
  filename = "${path.module}/tmp/${each.key}"
}
#
resource "aws_secretsmanager_secret" "sc" {
  for_each = toset(var.databases)
  name     = "${var.prefix}-${var.environment}-${each.key}-rds-postgresql"
  tags     = var.tags
}
#
resource "aws_secretsmanager_secret_version" "sc" {
  for_each  = toset(var.databases)
  secret_id = aws_secretsmanager_secret.sc[each.key].id
  # encode in the required format
  secret_string = jsonencode(
    {
      username = each.key
      password = random_password.internal_roles[each.key].result
      dbname   = each.key
      engine   = "postgresql"
      host     = var.host_db
      port     = "5432"
    }
  )
}