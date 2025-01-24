provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  default     = "us-east-1" # Default AWS region
  description = "AWS region to deploy resources in"
}

variable "instance_type" {
  default     = "t2.micro" # Default instance type
  description = "Type of EC2 instance to deploy"
}

variable "ami_id" {
  default     = "ami-0c02fb55956c7d316" # Ubuntu AMI for us-east-1
  description = "AMI ID for the EC2 instance"
}

variable "custom_webpage_text" {
  default     = "Deployed via Terraform"
  description = "Custom text to display on the Nginx webpage"
}

variable "env_name" {
  description = "Environment name (e.g., dev, prod)"
}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  # User data script to install Nginx and set up a custom webpage
  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y nginx
              echo "${var.custom_webpage_text}" > /var/www/html/index.html
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name        = "${var.env_name}-nginx-server"
    Environment = var.env_name
  }
}

output "instance_public_ip" {
  value       = aws_instance.nginx_server.public_ip
  description = "Public IP of the Nginx server"
}
