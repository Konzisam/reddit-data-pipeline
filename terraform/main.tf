terraform {
  backend "s3" {
    bucket = "car-predictor"
    key = "reddit-backend/terraform.tfstate"
    region = "eu-central-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}










