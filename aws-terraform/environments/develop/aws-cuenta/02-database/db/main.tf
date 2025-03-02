#
module "databases" {
  source = "../../../../../modules/database/db/v1"
  #
  region      = var.region
  environment = var.environment
  project     = var.project
  #
  cluster   = var.cluster
  databases = var.databases
  #
  username      = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["DATABASE_USER"]
  password      = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["DATABASE_PASS"]
  host_db       = split(":", jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["DATABASE_HOST"])[0]
  host_provider = "127.0.0.1"
  #
  tags = local.tags
}