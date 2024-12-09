# Lab 19: Remote Backend and LifeCycles Rules
- Implement the below diagram with Terraform.
- Store state file in remote backend. 
- Use create_before_destroy Lifecycle on the EC2 and verify it. Compare between different Lifecycles Rules.
## Overview
This lab focuses on deploying a simple AWS architecture using Terraform and implementing advanced Terraform features such as:
### 1- Remote Backend: Store the Terraform state file securely in an S3 bucket for team collaboration and centralized management.
### 2- Lifecycle Rules: Use create_before_destroy to ensure smooth replacement of resources (like EC2 instances) without downtime during updates.
## Infrastructure Diagram
### The architecture includes:
 - A VPC with a public subnet.
 - An EC2 instance in the public subnet.
 - A CloudWatch alarm to monitor the EC2 instance's CPU utilization.
 - An SNS topic to send email alerts if CPU usage exceeds 70%.
 - An Internet Gateway (IGW) for internet connectivity.
 - Terraform state management using a remote backend (S3 bucket).
## Prerequisites
### 1- Terraform Installed: Ensure Terraform is installed on your local machine.
### 2- AWS CLI Installed: AWS CLI must be configured with access credentials and a region.
### 3- S3 Bucket and DynamoDB Table:
 - Create an S3 bucket to store the Terraform state file.
 - Create a DynamoDB table for state locking (recommended for team collaboration).
### 4- SSH Key Pair: Ensure an SSH key pair is created for accessing the EC2 instance.
### 5- IAM Permissions: Ensure your IAM user/role has permissions for EC2, S3, SNS, CloudWatch, and DynamoDB.
## Steps to Implement
### Step 1: Remote Backend Setup
#### 1- Create an S3 bucket and DynamoDB table:
```
aws s3api create-bucket --bucket my-terraform-state --region us-east-1
aws dynamodb create-table \
  --table-name terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```
### 2- Configure the Terraform backend in main.tf:
```
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "lab19/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```
### Step 2: Define VPC and Subnet
#### Add resources for a VPC and a public subnet:
```
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}
```
### Step 3: Deploy EC2 with Lifecycle Rules
####  Create an EC2 instance with a lifecycle rule:
```
resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "jenkins"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "WebServer"
  }
}
```
### Step 4: Add CloudWatch and SNS
#### 1- Create an SNS topic and subscription:
```
resource "aws_sns_topic" "alerts" {
  name = "cpu-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"
}
```
#### 2- Add a CloudWatch alarm for EC2:
```
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name                = "HighCPUAlarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 70
  alarm_actions             = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = aws_instance.web.id
  }
}
```
### Step 5: Outputs
#### 1- Add outputs for VPC, EC2, and CloudWatch:
```
output "vpc_id" {
  value = aws_vpc.main.id
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "cloudwatch_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.cpu_high.arn
}
```
### Testing
1- Verify Remote Backend:
 - Check the S3 bucket for the Terraform state file after running terraform apply.
2- Test Lifecycle Rule:
 - Update the ami or instance_type of the EC2 instance and reapply the configuration.
 - Observe that Terraform creates a new EC2 instance before destroying the old one.
3- CloudWatch and SNS Alerts:
 - Simulate high CPU usage on the EC2 instance (e.g., run a CPU-intensive script).
 - Verify you receive an email alert from SNS.
### Cleanup
1- Destroy all resources:
```
terraform destroy
```
2- Delete the S3 bucket and DynamoDB table:
```
aws s3 rm s3://my-terraform-state --recursive
aws dynamodb delete-table --table-name terraform-lock
```
### Expected Output
#### 1- Terraform provisions:
 - A VPC with a public subnet.
 - An EC2 instance with create_before_destroy lifecycle behavior.
 - A CloudWatch alarm and SNS topic.
#### 2- Outputs displayed:
 - VPC ID
 - Public IP of EC2 instance
 - ARN of CloudWatch alarm.
#### 3- Email alerts are sent when EC2's CPU usage exceeds 70%.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us

