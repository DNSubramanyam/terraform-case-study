data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "allow-http" {
  name        = "case-study-sg"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow-http.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow-http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

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
  subnet_id               = data.aws_subnets.example.ids[count.index]
  security_groups         = [aws_security_group.allow-http.id]
  user_data               = "${file("userdata/${count.index}.sh")}"
  tags                    = merge(var.mandate_tags, {Name = "case-study-server-${var.ins_name[count.index]}"})
}
