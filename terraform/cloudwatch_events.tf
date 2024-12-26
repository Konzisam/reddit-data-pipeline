resource "aws_s3_bucket_notification" "s3_upload_trigger" {
  bucket = var.s3_bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.trigger_glue_job.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "raw/"
  }

  depends_on = [aws_lambda_permission.allow_s3_to_invoke_lambda]
}

resource "aws_lambda_permission" "allow_s3_to_invoke_lambda" {
  statement_id  = "AllowS3ToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger_glue_job.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.s3_bucket}"
}
