#
variable "environment" {}
variable "region" {}
variable "project" {}
# vpc
variable "cluster" {}
variable "databases" {}
variable "tags" {}
#
variable "username" {}
variable "password" {}
variable "host_provider" {}
variable "host_db" {}
#
variable "prefix" {
  type    = string
  default = "devops"
}