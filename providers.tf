terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
  backend "s3"{
    bucket = var.state_bucket
    key = var.state_bucket_key
    region = var.region
  }
}

provider "aws" {
  region     = var.region
  profile    = var.profile
}
