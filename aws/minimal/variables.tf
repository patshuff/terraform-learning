
provider "aws" {
  version = "> 2"
  profile = "default"
  region  = "us-east-1"
  alias   = "east"
}
provider "aws" {
  version = "> 2"
  profile = "default"
  region  = "us-west-1"
  alias   = "west"
}

variable "createdby" {
  type    = string
  default = "TechEnablement"
}

variable "environment" {
  type    = string
  default = "TechEnablement"
}

resource "aws_vpc" "myProdNet" {
  cidr_block           = "10.0.0.0/16"
  provider             = aws.east
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "Prod-1"
    environment = var.environment
    createdby   = var.createdby
  }
}

resource "aws_vpc" "myDevNet" {
  cidr_block           = "192.168.0.0/16"
  provider             = aws.west
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "Dev-1"
    environment = var.environment
    createdby   = var.createdby
  }
}