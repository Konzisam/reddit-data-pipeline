resource "aws_lambda_function" "trigger_glue_job" {
  filename      = "${var.glue_src_path}/lambda_deployment.zip"
  function_name = "trigger_glue_job"
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 30
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${var.glue_src_path}/lambda_function.py"
  output_path = "${var.glue_src_path}/lambda_deployment.zip"
}


resource "aws_lambda_permission" "allow_s3_to_invoke_lambda" {
  statement_id  = "AllowS3ToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger_glue_job.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.s3_bucket}"
}