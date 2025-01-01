resource "aws_s3_bucket" "reddit_bucket" {
  bucket = var.s3_bucket
}


resource "aws_s3_bucket_notification" "s3_upload_trigger" {
  bucket = var.s3_bucket

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "raw/"
  }

  depends_on = [var.lambda_permissions]
}