resource "aws_ssm_parameter" "redshift_password" {
  name        = "/redshift/password"
  description = "Password for the Redshift database"
  type        = "SecureString"
  value       = var.redshift_password
}

resource "aws_ssm_parameter" "redshift_connection_url" {
  name        = "/redshift/connection_url"
  description = "Connection url for Redshift"
  type        = "String"
  value       = var.redshift_connection_url
}

resource "aws_ssm_parameter" "s3_bucket_name" {
  name        = "/redshift/s3_bucket"
  description = "s3 bucket name"
  type        = "String"
  value       = var.s3_bucket
}

resource "aws_ssm_parameter" "glue_redshift_connection_name" {
  name        = "/redshift/glue_redshift_connection"
  description = "glue redshift connection name"
  type        = "String"
  value       = var.glue_redshift_connection_name
}

data "aws_caller_identity" "current" {}

resource "aws_ssm_parameter" "account_id" {
  name        = "/redshift/account_id"
  description = "awss account id"
  type        = "String"
  value       = "${data.aws_caller_identity.current.account_id}"
}
