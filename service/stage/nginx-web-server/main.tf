terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "../../../modules/vpc"
  cidr = "10.0.0.0/16"
  public_subnets    = [ "10.0.1.0/24", "10.0.2.0/24" ]
  private_subnets   = [ "10.0.11.0/24", "10.0.12.0/24" ]
  sg_ssh_allow_cidr = [ "87.110.167.23/32" ]
  sg_web_allow_cidr = [ "0.0.0.0/0" ]
}

module "ec2" {
  source = "../../../modules/ec2"
  instance_type = "t3.small"
  subnet_id = module.vpc.public_subnet_id[0]
  private_ip = [ "10.0.1.100" ] 
}