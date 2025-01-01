terraform {
  backend "s3" {
    bucket = "car-predictor"
    key    = "reddit-backend/terraform.tfstate"
    region = "eu-central-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
  region            = var.region
}

module "security_groups" {
  source                 = "./modules/security_groups"
  vpc_id                 = module.vpc.vpc_id
  web_access_cidr_blocks = var.web_access_cidr_blocks
  ssh_cidr_block         = var.ssh_cidr_block
}

module "s3" {
  source        = "./modules/s3"
  s3_bucket  = var.s3_bucket
  lambda_function_arn = module.lambda.lambda_function_arn
  lambda_permissions = module.lambda.lambda_permissions
}

module "iam" {
  source = "./modules/iam"
  s3_bucket = var.s3_bucket
  account_id = var.account_id
  glue_job_arn = module.glue.reddit_glue_job_arn
}

module "glue" {
  source          = "./modules/glue"
  s3_bucket              = var.s3_bucket
  glue_service_role_arn  = module.iam.glue_service_role_arn
  num_workers = 10
}

module "athena" {
  source           = "./modules/athena"
  catalog_database = module.crawler.aws_glue_catalog_database
}

module "redshift" {
  source        = "./modules/redshift"
}

module "crawler" {
  source = "./modules/crawler"
  s3_bucket = var.s3_bucket
  crawler_role_arn = module.iam.glue_crawler_role_arn

}

module "lambda" {
  source = "./modules/lambda"
  glue_src_path = local.glue_src_path
  s3_bucket = var.s3_bucket
  lambda_role_arn = module.iam.lambda_role_arn
}

module "ec2" {
  source = "./modules/ec2"
  ami = "ami-0a628e1e89aaedf80"
  instance_type = "t2.medium"
  private_ip = var.private_ip
  key_name = "mlflow-host"
  security_group_id = module.security_groups.security_group_id
  subnet_id = module.vpc.subnet_id
  internet_gateway = module.vpc.internet_gateway
  region = var.region
}

module "rds" {
  source = "./modules/rds"
  db_name = var.db_name
  db_username = var.db_username
}
