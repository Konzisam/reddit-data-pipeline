# Glue to use the role we are creating
data "aws_iam_policy_document" "glue_execution_assume_role_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "glue_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "glue:GetConnection",
      "glue:GetConnections"
    ]
    resources = ["arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:connection/glue-redshift-connection"]
  }

  statement {
    effect = "Allow"
    actions = [
      "redshift-serverless:GetWorkgroup",
      "redshift-serverless:GetNamespace",
      "redshift-serverless:GetCredentials"
    ]
    resources = [
      "arn:aws:redshift-serverless:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:workgroup/reddit-workgroup",
      "arn:aws:redshift-serverless:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:namespace/reddit-namespace"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket}",
      "arn:aws:s3:::${var.s3_bucket}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws-glue/jobs/output:*"]
  }
}

resource "aws_iam_role_policy" "glue_permissions" {
  name = "glue_permissions"
  role = aws_iam_role.glue_service_role.id
  policy = data.aws_iam_policy_document.glue_permissions.json  # Remove jsonencode()
}



resource "aws_iam_role" "glue_service_role" {
  name               = "AWSGlueServiceRole-reddit_glue"
  assume_role_policy = data.aws_iam_policy_document.glue_execution_assume_role_policy.json
  path               = "/service-role/"
}

# s3 policies
data "aws_iam_policy_document" "s3_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket}",
      "arn:aws:s3:::${var.s3_bucket}/*"
    ]
  }

}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "AWSGlueServiceRole-reddit_glue-EZCRC-s3Policy"
  description = "This policy will be used for Glue Crawler and Job execution. Please do NOT delete!"
  policy      = data.aws_iam_policy_document.s3_policy.json
  path        = "/service-role/"
}


resource "aws_iam_role_policy_attachment" "s3_permissions" {
  role       = aws_iam_role.glue_service_role.id
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "glue_redshift_serverless_access" {
  policy_arn = aws_iam_policy.redshift_serverless_policy.arn
  role       = aws_iam_role.glue_service_role.name
}

data "aws_iam_policy_document" "redshift_serverless_access_policy" {
  statement {
    actions = [
      "redshift-serverless:DescribeEndpoints",
      "redshift-serverless:GetCredentials",
      "redshift-serverless:ListDatabases",
      "redshift-serverless:Select",
      "redshift-serverless:Insert",
      "redshift-serverless:CopyFromS3"
    ]
    resources = [
      "arn:aws:redshift-serverless:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:workgroup/reddit-workgroup",
      "arn:aws:redshift-serverless:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:namespace/reddit-namespace"
    ]
  }

  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket}/*"
    ]
  }

  statement {
    actions = [
      "glue:UseConnection",
      "glue:GetConnections",    # Ensure Glue can list connections
      "glue:GetConnection"      # Ensure Glue can fetch specific connection details
    ]
    resources = [
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:connection/glue-redshift-connection"
    ]
  }
}

resource "aws_iam_policy" "redshift_serverless_policy" {
  name        = "GlueRedshiftServerlessAccessPolicy"
  description = "Policy to allow Glue to access Redshift Serverless"
  policy      = data.aws_iam_policy_document.redshift_serverless_access_policy.json
}


data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "redshift_serverless_access" {
  statement {
    effect = "Allow"
    actions = [
      "glue:GetTable",
      "glue:GetTableVersion",
      "glue:GetTableVersions",
      "glue:GetDatabase",
      "glue:CreateTable",
      "glue:UpdateTable",
      "glue:DeleteTable"
    ]
    resources = [
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog",
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/*",
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/*"
    ]
  }

  # statement {
  #   actions = [
  #     "s3:GetObject"
  #   ]
  #   resources = [
  #     "arn:aws:s3:::/transformed_latest/*"
  #   ]
  # }
}






#crawler roles

data "aws_iam_policy_document" "glue_crawler_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "glue_crawler_role" {
  name               = "glue-crawler-role"
  assume_role_policy = data.aws_iam_policy_document.glue_crawler_assume_role_policy.json
}

data "aws_iam_policy_document" "glue_crawler_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket}/raw/*",
      "arn:aws:s3:::${var.s3_bucket}/transformed_latest/*",
      "arn:aws:s3:::${var.s3_bucket}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "glue:GetTable",
      "glue:GetTableVersion",
      "glue:GetTableVersions",
      "glue:CreateTable",
      "glue:UpdateTable",
      "glue:DeleteTable",
      "glue:GetDatabase"
    ]
    resources = [
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog",
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/*",
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:${data.aws_region.current.name}:${var.account_id}:log-group:/aws-glue/crawlers:*"
    ]
  }
}

resource "aws_iam_policy" "glue_crawler_policy" {
  name        = "reddit_db"
  description = "Policy to allow Glue Crawler to access S3 and Glue Catalog"
  policy      = data.aws_iam_policy_document.glue_crawler_policy.json
}

resource "aws_iam_role_policy_attachment" "glue_crawler_policy_attachment" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = aws_iam_policy.glue_crawler_policy.arn
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
    resources = [var.glue_job_arn]
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



resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

#ssm policy for glue to access credentials in ssm
data "aws_iam_policy_document" "ssm_access_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParameterHistory",
      "ssm:DescribeParameters"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*"
    ]
  }
}

resource "aws_iam_policy" "ssm_access_policy" {
  name        = "GlueSSMAccessPolicy"
  description = "Policy to allow Glue to access SSM Parameters"
  policy      = data.aws_iam_policy_document.ssm_access_policy.json
}

resource "aws_iam_role_policy_attachment" "glue_ssm_access" {
  policy_arn = aws_iam_policy.ssm_access_policy.arn
  role       = aws_iam_role.glue_service_role.name
}

# # Redshift iam role
# resource "aws_iam_policy" "redshift_glue_policy" {
#   name        = "RedshiftGluePolicy"
#   description = "Policy to allow Redshift to read from Glue Catalog and S3"
#   policy      = data.aws_iam_policy_document.redshift_serverless_access.json
# }
#
#
# resource "aws_iam_role" "redshift_to_glue_role" {
#   name               = "redshift-to-glue-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action    = "sts:AssumeRole"
#         Effect    = "Allow"
#         Principal = {
#           Service = "redshift.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy_attachment" "redshift_to_glue_attachment" {
#   policy_arn = aws_iam_policy.redshift_glue_policy.arn
#   role       = aws_iam_role.redshift_to_glue_role.name
# }


