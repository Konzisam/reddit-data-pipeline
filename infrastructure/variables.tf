locals {
  glue_src_path = "${path.root}/../glue_job"
  # glue_src_path = "s3://${var.s3_bucket}/glue_job/job.py"
}

variable "s3_bucket" {}
variable "account_id" {}
variable "region" {}
variable "vpc_cidr_block" {}
variable "private_ip" {}
variable "ssh_cidr_block" {}
variable "web_access_cidr_blocks" {}
variable "subnet_cidr_block" {}
variable "db_name" {}
variable "db_username" {}
# variable "redshift_password" {}
# variable "redshift_connection_url" {}