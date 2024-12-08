# lab 14 : create VPC with 2 public subnets, launch 2 EC2s with Nginx and Apache installed using user data, create and configure a Load Balancer to access the 2 Web servers.
## Overview
In this lab, you will create a VPC with two public subnets, launch two EC2 instances with Nginx and Apache installed using user data, and set up an Application Load Balancer (ALB) to distribute traffic between the two web servers. This setup ensures high availability and load balancing between the web servers.
## Prerequisites
1- AWS account with proper permissions to create VPCs, EC2 instances, and Load Balancers.
2- A configured AWS CLI on your local machine.
3- An existing key pair to SSH into the EC2 instances.
4- Basic knowledge of VPC, subnets, EC2, and ALB concepts
## Steps Overview
1- Create a VPC with 2 public subnets.
2- Launch 2 EC2 instances (one with Nginx, one with Apache).
3- Configure Security Groups.
4- Set up a Load Balancer.
5- Test the Load Balancer.
### Step 1: Create a VPC
#### Navigate to the VPC Dashboard:
- Go to the AWS Management Console → VPC.
#### Create a VPC:
- Name: myproject-vpc
- IPv4 CIDR block: 10.1.0.0/16
#### Create 2 Public Subnets:
##### 1- Subnet 1:
- Name: myproject-Public-Subnet-1
- CIDR Block: 10.1.1.0/24
- Availability Zone: us-east-1a
##### 2- Subnet 2:
- Name: myproject-Public-Subnet-2
- CIDR Block: 10.1.2.0/24
- Availability Zone: us-east-1b
##### 3- Create and Attach Internet Gateway:
- Name: MyProject-IGW
- Attach the IGW to the myproject-vpc.
##### 4- Configure Route Tables:
- Create a new route table named Public-RouteTable.
- Add a route: 0.0.0.0/0 → Target: MyProject-IGW.
- Associate both public subnets with this route table.
### Step 2: Launch 2 EC2 Instances
#### Launch EC2 Instance 1 (Nginx):
- AMI: Amazon Linux 2
- Instance Type: t2.micro
- Subnet: myproject-Public-Subnet-1
- Security Group: Allow HTTP (port 80) and SSH (port 22).
- User Data:
```
#!/bin/bash
sudo yum update -y
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<h1>Welcome to MyProject Nginx Server</h1>" | sudo tee /usr/share/nginx/html/index.html
```
#### Launch EC2 Instance 2 (Apache):
- AMI: Amazon Linux 2
- Instance Type: t2.micro
- Subnet: myproject-Public-Subnet-2
- Security Group: Allow HTTP (port 80) and SSH (port 22).
- User Data:
```
#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Welcome to MyProject Apache Server</h1>" | sudo tee /var/www/html/index.html
```
### Step 3: Configure Security Groups
#### Create a Security Group for Load Balancer:
- Inbound Rules: Allow HTTP (port 80) from 0.0.0.0/0.
- Outbound Rules: Allow all traffic.
#### Assign EC2 Instances Security Groups:
Ensure both instances allow:
- HTTP access (port 80).
- SSH access (port 22).
### Step 4: Create a Load Balancer
#### Navigate to EC2 Dashboard:
Go to Load Balancers → Create Load Balancer.
#### Choose Load Balancer Type:
Application Load Balancer (ALB).
#### Configure the Load Balancer:
- Name: MyProject-ALB
- Scheme: Internet-facing
- Listeners: HTTP on port 80
- Availability Zones: Select the zones for myproject-Public-Subnet-1 and myproject-Public-Subnet-2.
#### Add Target Group:
- Name: MyProject-TG
- Target Type: Instance
- Register Targets: Add both EC2 instances (Nginx and Apache).
#### Create and Test:
1- Click Create Load Balancer.
2- Wait until the Load Balancer is active.
3- Copy its DNS name.
### Step 5: Test the Load Balancer
1- Open a web browser.
2- Enter the DNS name of the Load Balancer.
3- Refresh the page multiple times:
- Responses should alternate between the Nginx and Apache servers, indicating load balancing.
#### Cleanup (Optional):
1- Terminate the EC2 instances.
2- Delete the Load Balancer and Target Group.
3- Delete the VPC and associated resources.
### Expected Output
#### 1- VPC and Subnets:
- VPC: myproject-vpc
- Public Subnets: myproject-Public-Subnet-1, myproject-Public-Subnet-2
#### 2- EC2 Instances:
- Instance 1 (Nginx): Returns Welcome to MyProject Nginx Server.
- Instance 2 (Apache): Returns Welcome to MyProject Apache Server.
#### 3- Load Balancer:
- DNS: Accessing it alternates between Nginx and Apache outputs.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us







