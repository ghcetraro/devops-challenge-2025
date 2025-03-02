#
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.84.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.19.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
  }
}
#
provider "postgresql" {
  host             = aws_db_instance.default.endpoint
  username         = aws_db_instance.default.master_username
  password         = aws_db_instance.default.master_password
  database         = "postgres"
  sslmode          = "require"
  connect_timeout  = 10
  superuser        = false
  expected_version = var.cluster.version
}