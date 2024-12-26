resource "aws_redshiftserverless_workgroup" "reddit_workgroup" {
  namespace_name = aws_redshiftserverless_namespace.reddit_namespace.namespace_name
  workgroup_name = "reddit-workgroup"
  base_capacity  = 64
}

data "aws_iam_role" "redshift_role" {
  name = "AmazonRedshift-CommandsAccessRole-20241005T234228"
}

resource "aws_redshiftserverless_namespace" "reddit_namespace" {
  namespace_name       = "reddit-namespace"
  db_name              = "dev"
  default_iam_role_arn = data.aws_iam_role.redshift_role.arn
}

# output "redshift_endpoint" {
#   value = aws_redshiftserverless_workgroup.reddit_workgroup.endpoint
# }

# resource "null_resource" "create_external_schema" {
#   provisioner "local-exec" {
#     command = <<EOT
#       pgcli -h ${aws_redshiftserverless_workgroup.reddit_workgroup.endpoint[0].address} \
#       -p 5439 -U admin -d dev --ssl -c "CREATE EXTERNAL SCHEMA public \
#       FROM DATA CATALOG DATABASE 'dev' IAM_ROLE '${data.aws_iam_role.redshift_role.arn}' \
#       CREATE EXTERNAL DATABASE IF NOT EXISTS;"
#     EOT
#   }
#
#   depends_on = [
#     aws_redshiftserverless_workgroup.reddit_workgroup,
#     aws_redshiftserverless_namespace.reddit_namespace
#   ]
# }





