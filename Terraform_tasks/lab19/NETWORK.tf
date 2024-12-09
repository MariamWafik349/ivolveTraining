VPC 
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "Lab19 VPC"
  }
}
Subnet 
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true # Ensure instances launched in the subnet get public IPs

  tags = {
    Name = "Lab19 Public Subnet"
  }
}
Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Lab19 Internet Gateway"
  }
}
Route Table 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Allow traffic to the internet
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Lab19 Public Route Table"
  }
}

Route Table Association
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
