terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "cellanome-sqa-iam-roles-tf-state-bucket"
    key            = "iam/github-role/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "cellanome-sqa-iam-roles-tf-lock-table"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-west-1"
  profile = "default"
}
