variable "s3_bucket" {}
variable "redshift_connection_url" {
  type = string
}
variable "redshift_password" {
  sensitive = true
}
variable "glue_redshift_connection_name" {}