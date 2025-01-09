resource "aws_athena_database" "reddit_athena_db" {
  name = var.catalog_database
  # bucket = "s3://${var.s3_bucket}/athena_scripts/"
}

