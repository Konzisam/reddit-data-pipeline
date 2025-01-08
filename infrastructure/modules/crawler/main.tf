resource "aws_glue_crawler" "reddit_crawler" {
  name          = "reddit_crawler"
  role          = var.crawler_role_arn
  database_name = aws_glue_catalog_database.reddit_db.name

  s3_target {
    path = "s3://${var.s3_bucket}/transformed_latest/"
  }



}

resource "aws_glue_crawler" "reddit_raw_crawler" {
  name          = "reddit_raw_crawler"
  role          = var.crawler_role_arn
  database_name = aws_glue_catalog_database.reddit_db.name

  s3_target {
    path = "s3://${var.s3_bucket}/raw/"
  }
}

resource "aws_glue_catalog_database" "reddit_db" {
  name = "reddit_db"
}


