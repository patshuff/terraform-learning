provider "aws" {
  version = "> 2"
  profile = "default"
  region  = "us-east-1"
  alias   = "east"
}

resource "aws_instance" "myec2" {
   ami = "ami-082b5a644766e0e6f"
   provider  = aws.east
   instance_type = "t2.micro"
}
