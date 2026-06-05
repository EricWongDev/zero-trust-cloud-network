terraform {
  # This tells Terraform to store its memory in the AWS S3 Bucket
  backend "s3" {
    bucket = "zero-trust-tf-state-eric-0301" # <--- YOUR BUCKET NAME HERE
    key    = "hub-network/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}