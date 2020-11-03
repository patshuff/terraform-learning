resource "aws_vpc" "myNet" {
  cidr_block           = "10.0.0.0/16"
  provider             = aws.east
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "myNet"
    environment = var.environment
    createdby   = var.createdby
  }
}

resource "aws_internet_gateway" "igw" {
  provider = aws.east
  vpc_id   = aws_vpc.myNet.id
  tags = {
    Name        = "igw"
    environment = var.environment
    createdby   = var.createdby
  }
}

resource "aws_subnet" "mySubnet" {
  provider          = aws.east
#  availability_zone = element(data.aws_availability_zones.aws.names, 0)
  vpc_id            = aws_vpc.myNet.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name        = "mySubnet"
    environment = var.environment
    createdby   = var.createdby
  }
}

resource "aws_security_group" "cmvltRules" {
  provider    = aws.east
  name        = "cmvltRules"
  description = "allow ports 80, 443, 8400-8403 inbound traffic"
  vpc_id      = aws_vpc.myNet.id

  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 8400-8403 from anywhere"
    from_port   = 8400
    to_port     = 8403
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ssh from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow rdp from anywhere"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "cmvltRules"
    environment = var.environment
    createdby   = var.createdby
  }
}
