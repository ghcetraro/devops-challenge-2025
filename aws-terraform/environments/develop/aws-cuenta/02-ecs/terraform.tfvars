#
account     = "aws-account"
environment = "development"
project     = "devops"
region      = "us-east-1"
#
vpc = {
  #
  vpc_id    = "vpc-1234567890"    # vpc
  subnets_0 = "subnet-1234567890" # PrivateSubnet1
  subnets_1 = "subnet-1234567890" # PrivateSubnet2
  subnets_2 = "subnet-1234567890" # PublicSubnet1
  subnets_3 = "subnet-1234567890" # PublicSubnet2
  #
}
#
route53 = {
  host_id   = "<route 53 id>"
  host_zone = "devops.com"
}
#
cluster = {
  #
  name = "development-cluster"
  #
  cloudwatch_retention = "3"
  tag                  = "dummy-1.0.0" # to create the base images
  td_version           = "dummy-1.0.0" # to force new deployments
}
#
services = {
  "backend" = {
    short_name = "backend"
    priority   = "1"
    tag        = "dummy-1.0.0"
    #
    cpu           = 256
    memory        = 512
    essential     = true
    containerPort = 3000
    hostPort      = 3000
    #
    desired_count                      = 1
    deployment_minimum_healthy_percent = 50
    deployment_maximum_percent         = 200
    enable_ecs_managed_tags            = true
    #
    url     = ["backend.devops.com"]
    dns_url = "backend.devops.com"
  },
  "dealer" = {
    short_name = "dealer"
    priority   = "2"
    tag        = "dummy-1.0.0"
    #
    cpu           = 256
    memory        = 512
    essential     = true
    containerPort = 3000
    hostPort      = 3000
    #
    desired_count                      = 1
    deployment_minimum_healthy_percent = 50
    deployment_maximum_percent         = 200
    enable_ecs_managed_tags            = true
    #
    url     = ["dealer.devops.com"]
    dns_url = "dealer.devops.com"
  },
}
#


