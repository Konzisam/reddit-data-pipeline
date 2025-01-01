output "lambda_function_arn" {
  value = aws_lambda_function.trigger_glue_job.arn
}

output "lambda_permissions" {
  value = aws_lambda_permission.allow_s3_to_invoke_lambda
}