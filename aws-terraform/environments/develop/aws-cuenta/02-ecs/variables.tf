#
variable "account" {}
variable "environment" {}
variable "region" {}
variable "project" {}
# vpc
variable "cluster" {}
variable "vpc" {}
variable "services" {}
variable "route53" {}
#
variable "my_env_variables" {
  default = [
    {
      "name" : "ENVIRONMENT",
      "value" : "development"
    },
  ]
}
#
