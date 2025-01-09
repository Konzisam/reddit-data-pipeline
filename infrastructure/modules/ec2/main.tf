# resource "aws_network_interface" "web-server-nic" {
#   subnet_id       = var.subnet_id
#   private_ips     = [var.private_ip]
#   security_groups = [var.security_group_id]
#
#   # tags = {
#   #   "Name" = "web-server-nic"
#   # }
# }
#
# resource "aws_eip" "one" {
#   network_interface         = aws_network_interface.web-server-nic.id
#   associate_with_private_ip = var.private_ip
#
#   depends_on = [var.internet_gateway]
#
#   # tags = {
#   #   Name = "ElasticIP"
#   # }
# }
#
# resource "aws_instance" "airflow_server" {
#   ami               = var.ami
#   instance_type     = var.instance_type
#   key_name          = var.key_name
#   availability_zone = "${var.region}b"
#
#   root_block_device {
#     volume_size = 20
#     volume_type = "gp3"
#   }
#
#   ebs_block_device {
#     device_name           = "/dev/xvdb"
#     volume_size           = 20
#     volume_type           = "gp3"
#     delete_on_termination = true
#   }
#
#   network_interface {
#     device_index         = 0
#     network_interface_id = aws_network_interface.web-server-nic.id
#   }
#
#   tags = {
#     "Name" = "airflow server"
#   }
#
#   user_data = <<-EOF
#                 #!/bin/bash
#                 sudo apt update -y
#                 sudo apt install apache2 -y
#                 sudo systemctl start apache2
#                 sudo bash -c 'echo "Your very first web server" > /var/www/html/index.html'
#                 EOF
# }
#
# # output "server_public_ip" {
# #   value = aws_eip.elastic_ip.public_ip
# # }
