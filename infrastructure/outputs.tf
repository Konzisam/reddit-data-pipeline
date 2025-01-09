# output "server_public_ip" {
#   value = module.ec2.server_public_ip
# }

output "glue_service_role_arn" {
  value       = module.iam.glue_service_role_arn
}

output "glue_iam_role" {
  value = module.iam.glue_service_role_name
}