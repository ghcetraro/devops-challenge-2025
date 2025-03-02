#
variable "environment" {}
variable "region" {}
variable "project" {}
# vpc
variable "cluster" {}
variable "vpc" {}
variable "tags" {}
#
#
variable "kms_id" {
  type    = string
  default = null
}
#
variable "function_name" {
  type    = string
  default = "rds-rotate-secret"
}
#
variable "runtime" {
  type    = string
  default = "python3.11"
}
#
variable "handler" {
  type    = string
  default = "lambda_function.lambda_handler"
}
#
variable "timeout" {
  type    = string
  default = "30"
}
#
variable "subnet_ids" {
  type = list(string)
}