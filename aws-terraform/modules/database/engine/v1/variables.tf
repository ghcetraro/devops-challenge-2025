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
variable "master_username" {
  type    = string
  default = "root"
}
#
variable "storage_type" {
  default = "gp2"
}
#
variable "storage_encrypted" {
  type    = bool
  default = true
}
#
variable "db_name" {
  type    = string
  default = "postgres"
}