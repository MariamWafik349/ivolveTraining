# Lab 20: Terraform Variables and Loops
- Implement the below diagram with Terraform using variables for all arguments.
- do not repeat code.
- Install Nginx, Apache using remote provisioner.
- Create the NAT Gateway manually then make terraform manage it ‘Terraform import’.
- Output public ip and private ip of EC2s.
## Overview
### In this lab, you will:
1- Use Terraform variables to define arguments for reusable code and avoid repetition.
2- Install Nginx and Apache on EC2 instances using the remote-exec provisioner.
3- Manually create a NAT Gateway and import it into Terraform for management.
4- Use Terraform Loops (e.g., count or for_each) to dynamically create multiple resources.
5- Output the public and private IPs of the EC2 instances.
## Prerequisites
### Before starting the lab, ensure the following:
1- AWS Account with IAM access credentials.
2- Terraform Installed: Terraform version >=1.0.
 - Use terraform -v to verify.
3- AWS CLI Installed and configured.
 - Use aws configure to set up access and secret keys.
4- Key Pair: Create an AWS key pair for SSH access to EC2 instances.
5- Bastion Host (optional) if your instances will not have direct internet access.
6- Text Editor: VS Code, IntelliJ, or any editor of your choice.
7- SSH Client: To verify provisioner installations.
## Step-by-Step Implementation
### Step 1: Directory and File Setup
 - Organize your Terraform code files into a proper structure:
```
lab20/
│-- main.tf         # Main resource definitions
│-- variables.tf    # Input variables
│-- outputs.tf      # Outputs for EC2 IPs
│-- terraform.tfvars # Variable values
│-- userdata.sh     # Script for installing Nginx/Apache
``` 
### Step 2: Define Terraform Variables
 - Create a variables.tf file to define reusable input variables.
```
# Network Variables
variable "vpc_cidr" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "availability_zones" { type = list(string) }

# EC2 Variables
variable "ami" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }

# NAT Gateway Variables
variable "nat_eip" { type = string }

# Misc
variable "nginx_instances_count" { type = number }
variable "apache_instances_count" { type = number }
``` 
### Step 3: Write the Terraform Code
#### 3.1: VPC, Subnets, and Route Tables (main.tf)
```
# VPC
resource "aws_vpc" "lab_vpc" {
  cidr_block = var.vpc_cidr
  tags = { Name = "Lab20-VPC" }
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "Public-Subnet-${count.index + 1}" }
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = { Name = "Private-Subnet-${count.index + 1}" }
}

# Internet Gateway and Route Table
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab_vpc.id
  tags = { Name = "Lab20-IGW" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lab_vpc.id
  tags = { Name = "Public-RT" }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
```
#### 3.2: Import NAT Gateway
 - Manually create the NAT Gateway in AWS before importing it.
1- Manually Create a NAT Gateway in the AWS Console:
 - Assign an Elastic IP to the NAT Gateway.
2- Use terraform import to manage it:
```
terraform import aws_nat_gateway.lab_nat_gw nat-gateway-id
```
 - Add the following resource to main.tf:
```
resource "aws_nat_gateway" "lab_nat_gw" {
  allocation_id = var.nat_eip
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = { Name = "Lab20-NAT-GW" }
}
```
#### 3.3: EC2 Instances with Provisioners
 - Install Nginx and Apache using the remote-exec provisioner.
```
# Nginx Instances
resource "aws_instance" "nginx_servers" {
  count         = var.nginx_instances_count
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnets[0].id
  key_name      = var.key_name

  tags = { Name = "Nginx-Server-${count.index + 1}" }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo systemctl start nginx"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
}

# Apache Instances
resource "aws_instance" "apache_servers" {
  count         = var.apache_instances_count
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnets[0].id
  key_name      = var.key_name

  tags = { Name = "Apache-Server-${count.index + 1}" }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "sudo systemctl start apache2"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
}
```
### Step 4: Outputs
- Define outputs to display public and private IPs of EC2 instances:
#### outputs.tf:
```
output "nginx_public_ips" {
  value = aws_instance.nginx_servers[*].public_ip
}

output "nginx_private_ips" {
  value = aws_instance.nginx_servers[*].private_ip
}

output "apache_public_ips" {
  value = aws_instance.apache_servers[*].public_ip
}

output "apache_private_ips" {
  value = aws_instance.apache_servers[*].private_ip
}
```
#### Step 5: Apply the Configuration
`- Initialize Terraform:
```
terraform init
```
2- Validate the configuration:
```
terraform validate
```
3- Plan the deployment:
```
terraform plan
```
4- Apply the configuration:
```
terraform apply
```
### Expected Output
 1- VPC, Public Subnet, and NAT Gateway will be created.
 2- Nginx and Apache will be installed on separate EC2 instances.
 3- Outputs will display:
   - Public IPs and private IPs of Nginx servers.
   - Public IPs and private IPs of Apache servers.
### Changes Made to Align with Your Data
1- AMI Data Source: Updated to use Amazon Linux 2 (amzn2-ami-hvm-*), as it’s commonly used in AWS labs.
2- Instance Name: Tagged as "Lab20 EC2 Instance".
3- Security Group:
 - Added HTTP (port 80) to support Nginx.
 - Allowed SSH access (port 22).
4- Provisioner:
 - Installs and starts Nginx on Amazon Linux 2.
 - Ensures the service runs on boot with systemctl enable.
5- Connection:
 - Assumes you use ec2-user for Amazon Linux 2.
 - SSH key path set to ~/.ssh/id_rsa.
### Assumptions
 - aws_vpc.lab20_vpc and aws_subnet.public_subnet are defined in your main VPC configuration.
 - Your key pair (~/.ssh/id_rsa) exists and is associated with the EC2 instance.
### Summary
 - This configuration:
1- Retrieves the Amazon Linux 2 AMI.
2- Creates an EC2 instance.
3- Installs Nginx automatically using remote-exec.
4- Allows SSH and HTTP traffic via a security group.
5- Outputs the public and private IPs of the instance
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us
