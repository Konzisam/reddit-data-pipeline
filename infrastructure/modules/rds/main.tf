resource "aws_db_instance" "airflow_db" {
  allocated_storage = 20
  engine            = "postgres"
  instance_class    = "db.t4g.micro"
  db_name           = var.db_name
  username          = var.db_username
  # password             = var.db_password
  publicly_accessible     = false
  vpc_security_group_ids  = ["sg-0d5811826809163cf"]
  db_subnet_group_name    = "default-vpc-04febd17bfc709bcc"
  backup_retention_period = 1
  storage_encrypted       = true
  # apply_immediately = false
  performance_insights_enabled = true
  skip_final_snapshot          = true
  copy_tags_to_snapshot        = true
  max_allocated_storage        = 1000
}

# resource "aws_security_group" "rds_sg" {
#   vpc_id = aws_vpc.prod-vpc.id
#
#   # Allow inbound PostgreSQL traffic on port 5432 from EC2's security group
#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     security_groups = [aws_security_group.allow_web.id]  # EC2's security group
#   }
#
#   # Allow all outbound traffic (default)
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }



# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = "default-vpc-04febd17bfc709bcc"
#   subnet_ids = ["subnet-0d30a60cdcbe5db6c", "subnet-0dc35058533689b79", "subnet-0183872256b37c170"]
#
#   tags = {
#     Name = "default-vpc-04febd17bfc709bcc"
#   }
#
