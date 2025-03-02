#
terraform {
  backend "s3" {
    profile        = "devops"
    encrypt        = true
    bucket         = "aws-cuenta-develop-poc-github"
    region         = "us-east-1"
    dynamodb_table = "tfstatelocks"
    key            = "iac/environment/development/aws-cuenta/ecs.tfstate"
  }
}