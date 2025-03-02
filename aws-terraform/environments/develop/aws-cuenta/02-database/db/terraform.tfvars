#
account     = "aws-account"
environment = "development"
project     = "devops"
region      = "us-east-1"
#
cluster = {
  name    = "development-rds-cluster"
  engine  = "postgres"
  version = "16.4"
}
#
databases = [
  "backend-api-service",
  "backend-delaer-service",
]