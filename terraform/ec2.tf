# terraform import aws_vpc.prod-vpc vpc-xxxx
# 1. Create vpc
resource "aws_vpc" "prod-vpc" {
  cidr_block = var.vpc_cidr_block
}

# terraform import aws_internet_gateway.gw igw-xxx
# terraform state rm aws_internet_gateway.gw

# 2.  Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "main"
  }
}

# terraform import aws_subnet.subnet-1 subnet-xxx
# 3. Route table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Prod"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "${var.region}b"
  tags = {
    Name = "prod-subnet"
  }
}

# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# terraform import aws_security_group.allow_web sg-xxx
# 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  # name        = "airflow-server"
  name = "terraform-20241221154209814700000001"
  # description = "security group to allow only from my local"
  description = "launch-wizard-1 created 2024-11-14T17:18:51.845Z"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.web_access_cidr_blocks]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.web_access_cidr_blocks]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr_block]
  }

  ingress {
  description = "Airflow Webserver"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = [var.web_access_cidr_blocks]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
  revoke_rules_on_delete = false

  # lifecycle {
  #   ignore_changes = [ingress, egress]
  # }
}

# terraform import aws_network_interface.web-server-nic  eni-xxx
# 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = [var.private_ip]
  security_groups = [aws_security_group.allow_web.id]
}

resource "aws_eip" "one" {
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = var.private_ip
  depends_on                = [aws_internet_gateway.gw]
}

output "server_public_ip" {
  value = aws_eip.one.public_ip
}


# terraform import aws_instance.example i-xxxxx
# # 9. Create Ubuntu server and run airflow
resource "aws_instance" "airflow_server" {
  ami               = "ami-0084a47cc718c111a"
  instance_type     = "t2.micro"
  availability_zone = "${var.region}b"
  key_name          = "mlflow-host"

    # Root volume configuration (part of Free Tier)
  root_block_device {
    volume_size = 20            # Root volume size within Free Tier (<= 30 GiB)
    volume_type = "gp3"         # General Purpose SSD, Free Tier eligible
  }

  # Additional EBS volume (part of Free Tier)
  ebs_block_device {
    device_name = "/dev/xvdb"   # Specify the device name
    volume_size = 20            # Size of the additional volume (<= 30 GiB)
    volume_type = "gp3"         # General Purpose SSD, Free Tier eligible
    delete_on_termination = true # Ensure volume is deleted with instance
  }
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  tags = {
    "Name" = "airflow server"
  }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt-get install -y python3-pip
                # curl -fsSL https://get.docker.com -o get-docker.sh
                # sudo sh get-docker.sh
                #
                # # Add user to Docker group (so you don't need sudo to run docker)
                # sudo usermod -aG docker ubuntu
                #
                # sudo apt-get install -y curl
                # sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                # sudo chmod +x /usr/local/bin/docker-compose
                #
                # # Verify Docker and Docker Compose installation
                # docker --version
                # docker-compose --version
                EOF

  # user_data = <<-EOF
  #               #!/bin/bash
  #               sudo apt update -y
  #               sudo apt install apache2 -y
  #               sudo systemctl start apache2
  #               sudo bash -c 'echo your very first web server > /var/www/html/index.html'
  #               EOF


}