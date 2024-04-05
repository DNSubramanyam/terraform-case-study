
resource "aws_security_group" "allow-http" {
  name        = "case-study-sg"
  tags = var.mandate_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow-http.id
  from_port         = var.http_port
  ip_protocol       = "tcp"
  to_port           = var.http_port
  cidr_ipv4         = var.public_cidr
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow-http.id
  from_port         = var.https_port
  ip_protocol       = "tcp"
  to_port           = var.https_port
  cidr_ipv4         = var.public_cidr
}
resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.allow-http.id
  cidr_ipv4         = var.public_cidr
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_instance" "web_servers" {
  count                   = var.ins_count
  ami                     = data.aws_ami.amazon_linux_2.id
  instance_type           = var.ins_type
  subnet_id               = data.aws_subnets.example.ids[count.index]
  vpc_security_group_ids         = [aws_security_group.allow-http.id]
  user_data               = "${file("userdata/${count.index}.sh")}"
  tags                    = merge(var.mandate_tags, {Name = "case-study-web-server-${var.ins_name[count.index]}"})
}
