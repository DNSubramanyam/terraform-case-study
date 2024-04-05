output "result" {
  value = {
    ami-id           = data.aws_ami.amazon_linux_2.id
    target_group_arn = aws_lb_target_group.tf_cs_tg.arn
    alb_arn          = aws_lb.tf_cs_alb.arn
    alb_dns          = aws_lb.tf_cs_alb.dns_name
    website_url      = var.url
  }
}