variable "region" {}
variable "profile" {}
variable "state_bucket" {}
variable "state_bucket_key" {}

variable "ami_name"{}
variable "ins_type"{}
variable "ins_count"{}
variable "mandate_tags" {}
variable "ins_name" {
    type = list
    default = ["A", "B"]
}


