#
output "aws_lb_arn" {
  value = aws_lb.main_public.arn
}
#
output "aws_lb_dns" {
  value = aws_lb.main_public.dns_name
}