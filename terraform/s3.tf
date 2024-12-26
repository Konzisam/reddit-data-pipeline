resource "aws_s3_bucket" "reddit_bucket" {
  bucket = var.s3_bucket
}