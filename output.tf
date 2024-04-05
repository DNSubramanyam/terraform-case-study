output "result"{
  value = {
    ami-id = data.aws_ami.amazon_linux_2.id
    out = data.aws_subnets.example.ids
  }
}