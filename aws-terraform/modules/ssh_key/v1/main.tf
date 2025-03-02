#
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
#
resource "aws_key_pair" "ssh_key" {
  key_name   = var.aws_key_pair
  public_key = tls_private_key.ssh_key.public_key_openssh
}
#
resource "aws_ssm_parameter" "private" {
  name  = var.aws_ssm_parameter_private
  type  = "SecureString"
  value = tls_private_key.ssh_key.private_key_pem
  tags  = var.tags
}
#
resource "aws_ssm_parameter" "public" {
  name  = var.aws_ssm_parameter_public
  type  = "String"
  value = tls_private_key.ssh_key.public_key_openssh
  tags  = var.tags
}
#
resource "local_file" "ssh_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/tmp/private.key"
}