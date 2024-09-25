provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo-server" {
  ami = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"
  key_name = "terraformkey"
  security_groups = [ "demo-sg" ]
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "allow ssh"

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