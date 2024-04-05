variable "region" {}
variable "profile" {}

variable "ami_name"{}
variable "ins_type"{}
variable "ins_count"{}
variable "mandate_tags" {}
variable "ins_name" {
    type = list
    default = ["A", "B"]
}
variable "http_port" {}
variable "public_cidr" {}
variable "ssl_policy" {}
variable certificate_arn {}
variable "https_port" {}


variable "zone_id" {}
variable "url" {}