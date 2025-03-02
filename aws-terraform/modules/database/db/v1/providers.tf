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
  host             = var.host_provider
  username         = var.username
  password         = var.password
  database         = "postgres"
  port             = 5432
  sslmode          = "require"
  connect_timeout  = 10
  superuser        = false
  expected_version = var.cluster.version
}