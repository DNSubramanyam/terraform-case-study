resource "aws_route53_record" "example" {
  zone_id = var.zone_id
  name    = var.url
  type    = "A"
  alias {
    name                   = aws_lb.tf_cs_alb.dns_name
    zone_id                = aws_lb.tf_cs_alb.zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_lb.tf_cs_alb]
}

