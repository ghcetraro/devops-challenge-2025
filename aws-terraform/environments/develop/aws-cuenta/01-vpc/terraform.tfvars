#
account     = "aws-account"
environment = "development"
project     = "devops"
region      = "us-east-1"
#
vpc_cidr            = "10.1.0.0/16"
vpc_azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
vpc_private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24", ]
vpc_public_subnets  = ["10.1.5.0/24", "10.1.6.0/24"]