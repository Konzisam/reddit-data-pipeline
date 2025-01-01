resource "aws_lambda_function" "trigger_glue_job" {
  filename      = "${path.module}/lambda_deployment.zip"
  function_name = "trigger_glue_job"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 30
}

data "archive_file" "lambda_package" {
  type        = "zip"
  # source_file = "${path.module}/lambda_function.py"
  source_file = "${local.glue_src_path}/lambda_function.py"
  output_path = "${local.glue_src_path}/lambda_deployment.zip"
  # output_path = "${path.module}/lambda_deployment.zip"

}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_execution_role.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}

data "aws_iam_policy_document" "lambda_policy" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["glue:StartJobRun"]
    resources = [aws_glue_job.reddit_glue_job.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}
