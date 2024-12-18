# Security group for Proxy in AZ1
resource "aws_security_group" "az1_proxy_sg" {
  name        = "Proxy1 SG"
  description = "SG for Proxy in AZ1"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.lb1_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG for Proxy in AZ1"
  }
}

# Security group for Proxy in AZ2
resource "aws_security_group" "az2_proxy_sg" {
  name        = "Proxy2 SG"
  description = "SG for Proxy in AZ2"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.lb1_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG for Proxy in AZ2"
  }
}

# Security group for Backend WS in AZ1
resource "aws_security_group" "az1_ws_sg" {
  name        = "AZ1 WS SG"
  description = "SG for BE WS in AZ1"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups  = [aws_security_group.lb2_sg.id]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG for BE WS in AZ1"
  }
}

# Security group for Backend WS in AZ2
resource "aws_security_group" "az2_ws_sg" {
  name        = "AZ2 WS SG"
  description = "SG for BE WS in AZ2"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups  = [aws_security_group.lb2_sg.id]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG for BE WS in AZ2"
  }
}

# Security group for Public Load Balancer (LB1)
resource "aws_security_group" "lb1_sg" {
  name        = "LB1 SG"
  vpc_id = aws_vpc.main.id

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

# Security group for Internal Load Balancer (LB2)
resource "aws_security_group" "lb2_sg" {
  name        = "LB2 SG"
  vpc_id      = aws_vpc.main.id

  # Inbound rule to allow traffic from reverse proxy instances on port 80
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.az1_proxy_sg.id, aws_security_group.az2_proxy_sg.id]
  }

  # Outbound rule to allow traffic to the web servers (port 80)
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }


}

