region = "us-east-1"
profile = "subbu-tf"

ami_name="al2023-ami-2023.*-x86_64*"
ins_type="t2.micro"
ins_count=2
mandate_tags = {
    Environment = "Prod"
    Source = "Terraform"
    Project= "Terraform-Case-Study"
}
http_port = "80"
ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
certificate_arn = "arn:aws:acm:us-east-1:366951018568:certificate/51cf8fbd-0a32-4c9b-b866-acf1eeb73dcc"
https_port = "443"
public_cidr = "0.0.0.0/0"

zone_id = "Z0400132321GG1WNTEYB4"
url="casestudy.subbu98.xyz"