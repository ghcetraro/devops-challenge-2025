#
resource "aws_route53_record" "www" {
  for_each = var.services
  zone_id  = var.route53.host_id
  name     = lookup(each.value, "dns_url", each.key)
  type     = "CNAME"
  ttl      = 60
  records  = [aws_lb.main_public.dns_name]
}