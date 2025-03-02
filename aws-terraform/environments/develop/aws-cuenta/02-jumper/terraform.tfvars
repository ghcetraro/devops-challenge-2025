#
account     = "aws-account"
environment = "development"
project     = "devops"
region      = "us-east-1"
#
vpc = {
  #
  vpc_id    = "vpc-1234567890"        # vpc
  subnets_0 = "subnet-vpc-1234567890" # Public Subnet1
  subnets_1 = "subnet-vpc-1234567890" # Public Subnet2
  #
}
#
instance = {
  name                        = "development-jumper"
  instance_type               = "t3.small"              #x86
  ami                         = "ami-085ad6ae776d8f09c" #x86 Amazon Linux 2023 AMI
  associate_public_ip_address = true
  volume_size                 = "100"
  volume_type                 = "gp3"
  iops                        = "3000"
  encrypted                   = true
  #
}
#
cidr_blocks = ["123.456.789.000/32"]