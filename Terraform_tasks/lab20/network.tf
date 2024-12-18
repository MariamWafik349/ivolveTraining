# VPC resource 
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "Lab20 VPC"
  }
}
# Subnet resource 
resource "aws_subnet" "subnets" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = count.index == 0 ? var.pub_subnet_cidr_block : var.priv_subnet_cidr_block
  availability_zone = count.index == 0 ? var.az1 : var.az2
  map_public_ip_on_launch = count.index == 0 ? true : false
  
  tags = {
    Name = count.index == 0 ? "Lab20 Public Subnet" : "Lab20 Private Subnet"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Lab20 Internet Gateway"
  }
}
# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnets[0].id

  tags = {
    Name = "Lab20 NAT Gateway"
  }
}
# Route tables 
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Lab20 Main Route Table"
  }
}

resource "aws_route_table_association" "pub_association" {
  count          = 2
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.main.id
}
