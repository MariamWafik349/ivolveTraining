# Lab 17 - Multi-Tier Application Deployment with Terraform
## Main Requirments 
Create ‘ivolve’ VPC manually in AWS and use Data block to get VPC id in your configuration file. 
Use Terraform to define and deploy a multi-tier architecture including 2 subnets, EC2, and RDS database. 
Use local provisioner to write the EC2 IP in a file called ec2-ip.txt.
## Overview:
This lab focuses on deploying a multi-tier architecture using Terraform in AWS. The architecture includes:
1- A manually created VPC (ivolve VPC).
2- Two subnets for isolation of tiers (e.g., public and private).
3- An EC2 instance for the application layer.
4- An RDS database for the data layer.
5- Using a data block to retrieve the VPC ID dynamically.
6- Using a local provisioner to store the EC2 instance's IP address in a file (ec2-ip.txt).
## Prerequisites:
1- AWS Account:
- Ensure you have access to an AWS account.
- IAM user with required permissions (EC2, RDS, VPC, etc.).
2- Terraform Installed:
- Download and install Terraform from Terraform's official site.
3- AWS CLI:
- Install and configure AWS CLI with the proper access and secret keys (aws configure).
4- Manually Created VPC:
   - Create the VPC (ivolve) in AWS via the console with at least:
      - CIDR: 10.0.0.0/16.
- Note its name tag for retrieval.
5- Text Editor/IDE:
- Use an editor like VS Code with the Terraform extension installed.
6- Basic Knowledge:
- Familiarity with Terraform syntax and AWS services.
## Step-by-Step Guide:
### Step 1: Create ivolve VPC Manually
##### 1- Log in to the AWS Management Console.
##### 2- Go to VPC > Your VPCs > Create VPC.
##### 3- Configure:
 - Name tag: ivolve.
 - IPv4 CIDR block: 10.0.0.0/16.
##### 4- Save the VPC.
### Step 2: Initialize Terraform Project
#### 1- Create a directory for the project:
```
mkdir terraform-multi-tier && cd terraform-multi-tier
```
#### 2- Create the following files:
 - main.tf: Main configuration file.
 - variables.tf: For input variables.
 - outputs.tf: For outputs.
### Step 3: Write Terraform Configuration
##### main.tf:
```
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
```
##### variables.tf:
```
variable "region" {
  default = "us-east-1"
}
```
##### outputs.tf:
```
output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}
```
### Step 4: Initialize and Apply Terraform
##### Initialize Terraform:
```
terraform init
```
##### Validate the configuration:
```
terraform validate
```
##### Plan the deployment:
```
terraform plan
```
#### Deploy the architecture:
```
terraform apply
```
### Expected Output:
##### 1- A VPC (ivolve) with:
 - Two subnets (public and private).
 - An EC2 instance running in the public subnet.
 - An RDS MySQL database in a private subnet.
#### 2- A file ec2-ip.txt generated locally, containing the public IP address of the EC2 instance.
#### 3- Terraform output showing:
 - EC2 public IP address.
## Suggested Enhancements:
#### 1- IAM Role for EC2 Instance:
 - Attach an IAM role to the EC2 instance to securely access AWS services (e.g., S3 for logging or Secrets Manager for credentials).
```
resource "aws_iam_role" "ec2_role" {
  name = "ec2_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}
```
#### 2- CloudWatch for Monitoring:
 - Enable detailed monitoring for EC2 and RDS.
 - Add CloudWatch alarms to monitor critical metrics like CPU usage or database connections.
```
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "HighCPUUsage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  actions_enabled     = true
  alarm_actions       = [] # Add SNS topic ARN here
  dimensions = {
    InstanceId = aws_instance.app.id
  }
}
```
#### 3- Route53 for DNS:
- If applicable, use AWS Route53 to assign a user-friendly domain name to your EC2 instance or RDS endpoint.
#### 4-  EC2 User Data Script:
- Use a user data script to install required packages on the EC2 instance automatically during creation.
```
user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y httpd mysql
systemctl enable httpd
systemctl start httpd
EOF
```
#### 5- Output Enhancements:
 - Add outputs for subnet IDs and the VPC ID for better debugging or reference.
```
output "vpc_id" {
  value = data.aws_vpc.selected.id
}

output "subnet_ids" {
  value = [aws_subnet.public.id, aws_subnet.private.id]
}
```
#### 6- Testing:
 - Add a test to verify that the RDS is not publicly accessible by attempting a connection from outside the private subnet.
#### 7- Security Recommendations:
 - Use AWS Systems Manager to run commands on your EC2 instance instead of SSH for better security.
 - Encrypt RDS storage and backups.
 - Use parameterized security group rules instead of hardcoding CIDR ranges.
```
variable "allowed_cidr" {
  default = "0.0.0.0/0"
}

resource "aws_security_group_rule" "ssh_access" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.allowed_cidr]
}
```
#### 8- State Management:
Use a remote backend (e.g., S3 with DynamoDB) to manage your Terraform state securely.
```
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "NTI.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```
#### 9- Database Configuration:
- Ensure the RDS database is configured with backup retention (e.g., backup_retention_period = 7) and multi-AZ for production environments.
##### 10- Testing Database Connection from EC2:
- Use the following command to ensure proper connectivity:
```
mysql -h <rds-endpoint> -u your_username -p
```
# 🙏 Thank You
