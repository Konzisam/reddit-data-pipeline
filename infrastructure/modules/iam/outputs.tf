output "glue_service_role_arn" {
  value = aws_iam_role.glue_service_role.arn
}

output "glue_crawler_role_arn" {
  value = aws_iam_role.glue_crawler_role.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}
