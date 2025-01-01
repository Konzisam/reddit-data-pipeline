# terraform import aws_glue_job.reddit_glue_job reddit_job_latest
resource "aws_glue_job" "reddit_glue_job" {
  name              = "reddit_job_latest"
  role_arn          = var.glue_service_role_arn
  glue_version      = "4.0"
  max_retries       = 0 #optional
  description       = ""
  number_of_workers = var.num_workers
  worker_type       = "G.1X"
  timeout           = "2880"
  execution_class   = "STANDARD"

  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_bucket}/glue_scripts/jobs.py"
    python_version  = "3"
  }
  default_arguments = {
    "--S3_BUCKET"                        = var.s3_bucket
    "--enable-metrics"                   = "true"
    "--enable-spark-ui"                  = "true"
    "--spark-event-logs-path"            = "s3://${var.s3_bucket}/sparkHistoryLogs/"
    "--enable-job-insights"              = "true",
    "--enable-observability-metrics"     = "true"
    "--enable-glue-datacatalog"          = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--job-bookmark-option"              = "job-bookmark-disable"
    "--job-language"                     = "python"
    "--TempDir"                          = "s3://${var.s3_bucket}/temporary/"
  }
}

# resource "aws_s3_object" "deploy_script_s3" {
#   bucket = var.s3_bucket
#   key    = "glue_scripts/jobs.py"
#   source = "${local.glue_src_path}job.py"
#   etag   = filemd5("${local.glue_src_path}job.py")
# }