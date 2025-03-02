#
output "jumper" {
  value = aws_instance.jumper.public_ip
}