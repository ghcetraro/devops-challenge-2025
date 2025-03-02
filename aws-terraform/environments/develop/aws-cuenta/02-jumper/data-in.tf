#
data "terraform_remote_state" "ssh" {
  backend = "s3"
  config = {
    profile        = "devops"
    encrypt        = true
    bucket         = "aws-cuenta-develop-poc-github"
    region         = "us-east-1"
    dynamodb_table = "tfstatelocks"
    key            = "iac/environment/development/aws-cuenta/ssh_key.tfstate"
  }
}