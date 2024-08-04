terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.60.0"
    }
  }
  backend "s3" {
    bucket = "tf-s3-remote"
    key = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "tf-table1"
    
  }
}



provider "aws" {
  # Configuration options
  region="ap-south-1"
#   access_key = "my-access-key"
#   secret_key = "my-secret-key"
}




resource "aws_vpc" "ownvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "own-vpc"
  }
}

module "myserver-subnet"{
    source="./modules/subnet"
    vpc_id = aws_vpc.ownvpc.id
    subnet_cidr_block = var.subnet_cidr_block
    az=var.az
    env=var.env
}


module "myserver" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.ownvpc.id
  subnet_id = module.myserver-subnet.subnet.id   
  env = var.env
  instance_type = var.instance_type
}

# resource "aws_instance" "web" {
#   #count=2  
#   ami           = "ami-0d473344347276854"
#   #instance_type = "t2.micro"
#   instance_type = var.instance_type

#   tags = {
#     #Name = "HelloWorld1"
#     #Name= "tf ${count.index}"
#     Name= "tf"
#   }
# }



