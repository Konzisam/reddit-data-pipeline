# terraform import aws_glue_job.reddit_glue_job reddit_job_latest
resource "aws_glue_job" "reddit_glue_job" {
  name              = "reddit_job_latest"
  role_arn          = var.glue_service_role_arn
  glue_version      = "4.0"
  max_retries       = 0
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

  #   network {
  #   vpc_id = var.vpc_id  # VPC ID
  #   subnet_ids = var.subnet_ids  # List of Subnet IDs
  #   security_group_ids = var.security_group_ids  # List of Security Group IDs
  # }

  connections = [aws_glue_connection.glue_redshift_connection.name]
}

resource "aws_glue_connection" "glue_redshift_connection" {
  name = "glue-redshift-connection"

  connection_properties = {
    JDBC_CONNECTION_URL = var.jdbc_connection_url
    USERNAME            = "admin"
    PASSWORD            = var.redshift_password
  }

  physical_connection_requirements {
    subnet_id              = var.subnet_id
    security_group_id_list = ["sg-0d5811826809163cf"]
  }
}


resource "aws_s3_object" "deploy_script_s3" {
  bucket = var.s3_bucket
  key    = "glue_scripts/jobs.py"
  source = join("/", [var.glue_src_path, "job.py"])
  etag   = filemd5(join("/", [var.glue_src_path, "job.py"]))
}

# resource "aws_s3_object" "deploy_script_try" {
#   bucket = var.s3_bucket
#   key    = "glue_scripts/jobs.py"
#   source = join("/", [var.glue_src_path, "job.py"])
#   etag   = filemd5(join("/", [var.glue_src_path, "job.py"]))
# }


