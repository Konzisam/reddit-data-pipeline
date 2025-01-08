output "reddit_glue_job_arn" {
  value = aws_glue_job.reddit_glue_job.arn
}

output "glue_redshift_connection_name" {
  value = aws_glue_connection.glue_redshift_connection.name
}