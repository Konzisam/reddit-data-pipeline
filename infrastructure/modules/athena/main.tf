resource "aws_athena_database" "reddit_athena_db" {
  name = var.catalog_database
  # bucket = "s3://${var.s3_bucket}/athena_scripts/"
}

# output "athena_query_example" {
#   value = <<EOT
#   SELECT *
#   FROM "${aws_glue_catalog_database.reddit_db.name}"."transformed_latest"
#   LIMIT 10;
# EOT
# }