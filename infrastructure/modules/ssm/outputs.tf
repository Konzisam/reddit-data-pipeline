output "redshift_connection_url" {
  value = aws_ssm_parameter.redshift_connection_url
}

output "redshift_password" {
  value = aws_ssm_parameter.redshift_password.value
}

output "jdbc_connection_url" {
  value = aws_ssm_parameter.redshift_connection_url.value
}
