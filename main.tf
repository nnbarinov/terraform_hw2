terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region  = "eu-north-1"
}

data "aws_ami" "websrv" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.websrv.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_access.id]
  user_data = <<EOF
#!/bin/bash
apt update
apt -y install nginx
EOF
  tags = {
    project = "Epam"
  }
}

resource "aws_security_group" "web_access" {
  name        = "allow_http"
  description = "Allow http inbound traffic"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    project = "Epam"
  }
}
resource "aws_db_instance" "education" {
  identifier             = "education"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  username               = "pguser"
  password               = var.db_password
  skip_final_snapshot    = true
  tags = {
    project = "Epam"
  }
}