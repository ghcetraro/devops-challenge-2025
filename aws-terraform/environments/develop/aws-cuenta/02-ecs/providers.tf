#
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.84.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.2"
    }
  }
}
#
provider "aws" {
  region  = var.region
  profile = local.aws_profile
}
#
provider "docker" {
  registry_auth {
    address     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
    config_file = pathexpand("~/.docker/config.json")
  }
}