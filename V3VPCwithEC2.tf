provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo-server" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name = "terraformkey"
  //security_groups = [ "demo-sg" ]
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id = aws_subnet.public-subnet1.id
  for_each = toset(["jenkins-master", "jenkins-slave", "ansible"])
   tags = {
     Name = "${each.key}"
   }
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "allow ssh"
  vpc_id = aws_vpc.first-vpc.id

  ingress {
    description = "ssh access"
    cidr_blocks   = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress  {
    description = "ssh access"
    cidr_blocks   = ["0.0.0.0/0"]
    from_port   = 0
    protocol = "-1"
    to_port     = 0
  }
  

  tags = { 
    Name = "ssh prot"
  }

}

resource "aws_vpc" "first-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "first-vpc"
  }
  
}

resource "aws_subnet" "public-subnet1" {
  vpc_id = aws_vpc.first-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-subnet1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id = aws_vpc.first-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-subnet2"
  }
}

resource "aws_internet_gateway" "first-ig" {
  vpc_id = aws_vpc.first-vpc.id
  tags = {
    Name = "first-ig"
  }
}

resource "aws_route_table" "first-public-rt" {
  vpc_id = aws_vpc.first-vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.first-ig.id
  }
    
}

resource "aws_route_table_association" "rta-pub-sub1" {
  subnet_id = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.first-public-rt.id
}

resource "aws_route_table_association" "rta-pub-sub2" {
  subnet_id = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.first-public-rt.id
}