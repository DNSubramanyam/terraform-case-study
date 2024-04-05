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