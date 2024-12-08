# lab 13 : Create a VPC with public and private subnets and 1 EC2 in each subnet, configure private EC2 security group to only allow inbound SSH from public EC2 IP, SSH to the private instance using bastion host. 
## Overview
This task involves setting up a Virtual Private Cloud (VPC) with a public subnet and a private subnet. An EC2 instance will be deployed in each subnet. The public EC2 instance will act as a bastion host to SSH into the private EC2 instance. Security group configurations will ensure restricted access to the private EC2 instance, allowing SSH only from the public EC2's IP.
## Prerequisites
1- AWS Account: An active AWS account with permissions to create and manage VPCs, subnets, security groups, and EC2 instances.
2- AWS CLI: Installed and configured with appropriate credentials (aws configure).
3- Key Pair: A valid AWS key pair for SSH access. Create one if necessary:
```
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem
chmod 400 MyKeyPair.pem
```
4- SSH Client: A terminal or tool to SSH into the EC2 instances.
5- IAM Role for EC2 (Optional): If necessary for additional tasks like SSM.
## Step-by-Step Guide
### Step 1: Create a VPC
#### 1- Command:
```
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text
```
Save the VPC ID 
#### 2- Enable DNS Hostnames:
```
aws ec2 modify-vpc-attribute --vpc-id <VPC_ID> --enable-dns-hostnames
```
## Step 2: Create Subnets
### 1- Create a Public Subnet:
```
aws ec2 create-subnet --vpc-id <VPC_ID> --cidr-block 10.0.1.0/24 --query 'Subnet.SubnetId' --output text
```
Save the Subnet ID 
### 2- Create a Private Subnet:
```
aws ec2 create-subnet --vpc-id <VPC_ID> --cidr-block 10.0.2.0/24 --query 'Subnet.SubnetId' --output text
```
Save the Subnet ID 
## Step 3: Create and Attach an Internet Gateway
### 1- Command:
```
aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text
```
Save the IGW ID 
### 2- Attach to VPC:
```
aws ec2 attach-internet-gateway --vpc-id <VPC_ID> --internet-gateway-id <IGW_ID>
```
## Step 4: Create Route Tables
### 1- Create a Route Table for Public Subnet:
```
aws ec2 create-route-table --vpc-id <VPC_ID> --query 'RouteTable.RouteTableId' --output text
```
Save the Route Table ID 
### 2- Add a Route to the Internet Gateway:
```
aws ec2 create-route --route-table-id <RTB_ID> --destination-cidr-block 0.0.0.0/0 --gateway-id <IGW_ID>
```
### 3- Associate the Route Table with Public Subnet:
```
aws ec2 associate-route-table --route-table-id <RTB_ID> --subnet-id <PUBLIC_SUBNET_ID>
```
## Step 5: Create Security Groups
### 1- Public Security Group (Allow SSH):
```
aws ec2 create-security-group --group-name PublicSG --description "Public SG" --vpc-id <VPC_ID>
```
Save the Security Group ID 
### 2- Private Security Group (Allow SSH only from Public EC2):
```
aws ec2 create-security-group --group-name PrivateSG --description "Private SG" --vpc-id <VPC_ID>
```
Save the Security Group ID 
### 3- Add Rules:
- Public SG:
```
aws ec2 authorize-security-group-ingress --group-id <Public_SG_ID> --protocol tcp --port 22 --cidr 0.0.0.0/0
```
- Private SG:
```
aws ec2 authorize-security-group-ingress --group-id <Private_SG_ID> --protocol tcp --port 22 --source-group <Public_SG_ID>
```
## Step 6: Launch EC2 Instances
### 1- Launch Public EC2:
```
aws ec2 run-instances --image-id <AMI_ID> --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids <Public_SG_ID> --subnet-id <PUBLIC_SUBNET_ID>
```
Save the Public EC2 ID and Public IP.
### 2- Launch Private EC2:
```
aws ec2 run-instances --image-id <AMI_ID> --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids <Private_SG_ID> --subnet-id <PRIVATE_SUBNET_ID>
```
Save the Private EC2 ID.
## Step 7: Connect to Private EC2 via Bastion Host
### 1- SSH into the Public EC2:
```
ssh -i MyKeyPair.pem ec2-user@<Public_EC2_Public_IP>
```
### 2- From the Public EC2, SSH into the Private EC2:
```
ssh -i MyKeyPair.pem ec2-user@<Private_EC2_Private_IP>
```
## Expected Output
### 1- VPC, Subnets, and Security Groups:
#### Commands return resource IDs:
- VPC: vpc-12345678
- Public Subnet: subnet-11111111
- Private Subnet: subnet-22222222
- Internet Gateway: igw-87654321
- Security Groups: sg-11111111 (Public SG), sg-22222222 (Private SG)
### 2- Instances:
##### aws ec2 describe-instances command lists both:
###### Public EC2:
- Instance ID: i-11111111
- Public IP: 3.3.3.3
###### Private EC2:
- Instance ID: i-22222222
- Private IP: 10.0.2.100
#### 3- SSH Connection:
- Successfully SSH into the Public EC2 using its Public IP.
- From the Public EC2, SSH into the Private EC2 using its Private I
## Commands Recap
### 1- Create VPC:
```
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text
```
Output: vpc-12345678
### 2- Create Subnets:
#### Public Subnet:
```
aws ec2 create-subnet --vpc-id vpc-12345678 --cidr-block 10.0.1.0/24 --query 'Subnet.SubnetId' --output text
```
Output: subnet-11111111

#### Private Subnet:
```
aws ec2 create-subnet --vpc-id vpc-12345678 --cidr-block 10.0.2.0/24 --query 'Subnet.SubnetId' --output text
```
Output: subnet-22222222
### 3- Create Internet Gateway:
```
aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text
```
Output: igw-87654321
#### Attach to VPC:
```
aws ec2 attach-internet-gateway --vpc-id vpc-12345678 --internet-gateway-id igw-87654321
```
### 4- Create Route Table:
```
aws ec2 create-route-table --vpc-id vpc-12345678 --query 'RouteTable.RouteTableId' --output text
```
Output: rtb-12345678
#### Add route to IGW:
```
aws ec2 create-route --route-table-id rtb-12345678 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-87654321
```
#### Associate with Public Subnet:
```
aws ec2 associate-route-table --route-table-id rtb-12345678 --subnet-id subnet-11111111
```
### 5- Create Security Groups:
#### Public Security Group:
```
aws ec2 create-security-group --group-name PublicSG --description "Public SG" --vpc-id vpc-12345678
```
Output: sg-11111111
#### Add inbound SSH rule:
```
aws ec2 authorize-security-group-ingress --group-id sg-11111111 --protocol tcp --port 22 --cidr 0.0.0.0/0
```
#### Private Security Group:
```
aws ec2 create-security-group --group-name PrivateSG --description "Private SG" --vpc-id vpc-12345678
```
Output: sg-22222222
#### Add inbound SSH rule:
```
aws ec2 authorize-security-group-ingress --group-id sg-22222222 --protocol tcp --port 22 --source-group sg-11111111
```
### 6- Launch EC2 Instances:
#### Public EC2:
```
aws ec2 run-instances --image-id ami-12345678 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-11111111 --subnet-id subnet-11111111
```
Output: Instance ID: i-11111111
#### Private EC2:
```
aws ec2 run-instances --image-id ami-12345678 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-22222222 --subnet-id subnet-22222222
```
Output: Instance ID: i-22222222
### 7- Connect to EC2 Instances:
#### SSH into Public EC2:
```
ssh -i MyKeyPair.pem ec2-user@3.3.3.3
```
#### From Public EC2, SSH into Private EC2:
```
ssh -i MyKeyPair.pem ec2-user@10.0.2.100
```
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us



