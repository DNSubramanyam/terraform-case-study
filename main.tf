
resource "aws_lb_target_group" "tf-cs-tg"{
    name = "tf-case-study-tg"
    vpc_id = data.aws_vpc.default.id
    target_type = "instance"
    port = var.http_port
    protocol = "HTTP"
}

resource "aws_lb_target_group_attachment" "tf-cs-tg-attchment"{
    for_each = {
        for k,v in aws_instance.web_servers:
        k=>v
    }
    target_group_arn = aws_lb_target_group.tf-cs-tg.arn
    target_id = each.value.id
    depends_on = [ aws_instance.web_servers ]
}

resource "aws_lb" "tf_cs_alb" {
  name               = "tf-case-study-proj-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = slice(data.aws_subnets.example.ids,0,2)
  depends_on = [ aws_lb_target_group_attachment.tf-cs-tg-attchment ]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.tf_cs_alb.arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf-cs-tg.arn
  }
  depends_on = [ aws_lb.tf_cs_alb ]
}

resource "aws_route53_record" "example" {
  zone_id = var.zone_id
  name    = var.url
  type    = "A"
  alias {
    name                   = aws_lb.tf_cs_alb.dns_name
    zone_id                = aws_lb.tf_cs_alb.zone_id
    evaluate_target_health = true
  }

  depends_on = [ aws_lb.tf_cs_alb ]
}

