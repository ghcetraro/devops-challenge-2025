#
account     = "aws-account"
environment = "development"
project     = "devops"
region      = "us-east-1"
#
vpc = {
  #
  vpc_id    = "vpc-1234567890"    # vpc
  subnets_0 = "subnet-1234567890" # Private Subnet1
  subnets_1 = "subnet-1234567890" # Private Subnet2
  #
}
#
cluster = {
  #
  name                         = "development-rds-cluster"
  instance_class               = "db.t3.medium"
  engine                       = "postgres"
  version                      = "16.3"
  allocated_storage            = "200"
  preferred_maintenance_window = "tue:10:00-tue:11:00"
  #
}
#