# terraform {
#   backend "s3" {
#     bucket = var.infra_bucket
#     key = "reddit-backend/terraform.tfstate"
#     region = "eu-central-1"
#     dynamodb_table = "terraform-lock"
#   }
#
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

provider "aws" {
  region  = var.region
  # profile = "default"
}








