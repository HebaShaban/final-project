provider "aws" {
    region = "us-east-1"
}
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        "Name"= "new"
        project= "final-project"
    }
}
resource "aws_subnet" "tf_subnet1" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.vpc.id
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
     tags = {
        Name = "tf_subnet1"
    }
}
resource "aws_subnet" "tf_subnet2" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.vpc.id
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
     tags = {
        Name = "tf_subnet2"
    }
}
resource "aws_internet_gateway" "tf_IGW" {
  vpc_id = aws_vpc.vpc.id
    tags = {
    Name = "tf_IGW"
  }
}
resource "aws_route_table" "tf_routetable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_IGW.id
  }
   tags = {
    Name = "tf_routetable"
  }
}
resource "aws_route_table_association" "tf_routetable_association1" {
  subnet_id      = aws_subnet.tf_subnet1.id
  route_table_id = aws_route_table.tf_routetable.id
}
resource "aws_route_table_association" "terraform_routeTable_association2" {
  subnet_id      = aws_subnet.tf_subnet2.id
  route_table_id = aws_route_table.tf_routetable.id
}
resource "aws_security_group" "tf_securityGroup" {
  name        = "tf_securityGroup"
  description = "Allow HTTP and SSH traffic"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTPS connections"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }
    ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All traffic connections"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags = {
    Name = "tf_securityGroup"
  }
}

