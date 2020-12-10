terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/mluc/.aws/credentials"
  profile = "mluc"
  
}

# Create a VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "My-Vpc"
    }
}

# Create a Subnet
resource "aws_subnet" "sub"{
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "My-subnet"
    }


}

resource "aws_instance" "web"{

    ami = "ami-04d29b6f966df1537"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.sub.id
    
    security_groups = [aws_security_group.Security.id]
    tags = {
        Name = "My-private-VM"
    }
    
}


resource "aws_security_group" "Security"{

    name = "Security-group"
    vpc_id = aws_vpc.main.id


    ingress{
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }
    ingress{
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }
    egress{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]


    }
    


}