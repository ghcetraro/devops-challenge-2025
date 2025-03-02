#
variable "key_name" {
  type    = string
  default = "linux"
}
#
variable "tags" {}
#
variable "aws_ssm_parameter_private" {
  type    = string
  default = "ssh-private-key-ec2"
}
#
variable "aws_ssm_parameter_public" {
  type    = string
  default = "ssh-public-key-ec2"
}
#
variable "aws_key_pair" {
  type    = string
  default = "ssh-private-key-ec2"
}