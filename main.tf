# data "aws_vpc" "default" {
#   default = true
# }

# resource "aws_security_group" "allow-http" {
#   name        = "case-study-sg"
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = aws_security_group.allow-http.id
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.allow-http.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "this" {
  count                   = var.ins_count
  ami                     = data.aws_ami.amazon_linux_2.id
  instance_type           = var.ins_type
  subnet_id               = data.aws_vpc.default.subnets[count.index].id
  security_groups         = [aws_security_group.allow-http.name]
  user_data               = "${file("userdata/'${count.index}'.sh")}"
  tags                    = merge(var.mandate_tags, {Name = "case-study-server-${var.ins_name[count.index]}"})
}


resource "aws_lb_target_group" "tf-cs-tg"{
    name = "tf-case-study-tg"
    target_type = "alb"
    port = 80
    protocol = "HTTP"
}

resource "aws_lb_target_group_attachment" "tf-cs-tg-attchment"{
    for_each = {
        for k,v in aws_aws_instance.this:
        k=>v
    }
    target_group_arn = aws_lb_target_group.tf-cs-tg.arn
    target_id = each.value.id
}

output "result"{
  value = {
    ami-id = data.aws_ami.amazon_linux_2.id
  }
}