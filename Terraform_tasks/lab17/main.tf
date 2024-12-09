provider "aws" {
  region = "us-east-1"
}

# Data block to fetch VPC ID
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["ivolve"]
  }
}

# Create two subnets
resource "aws_subnet" "public" {
  vpc_id            = data.aws_vpc.selected.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.selected.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private Subnet"
  }
}

# Security group for EC2
resource "aws_security_group" "ec2_sg" {
  vpc_id = data.aws_vpc.selected.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "EC2 Security Group"
  }
}

# Create EC2 instance
resource "aws_instance" "app" {
  ami           = "ami-0c02fb55956c7d316" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "App Server"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2-ip.txt"
  }
}

# Create RDS instance
resource "aws_db_instance" "rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password123"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  skip_final_snapshot = true
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}
