variable "ubuntu-version" {
  type    = string
  default = "bionic"
  #  default = "xenial"
  #  default = "groovy"
  #  default = "focal"
  #  default = "trusty"
}

data "aws_ami" "ubuntu" {
  provider    = aws.east
  most_recent = true
  #  owners   = ["Canonical"]
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-${var.ubuntu-version}-*-amd64-server-*"]
  }
}

output "Ubuntu_image_name" {
  value = "${data.aws_ami.ubuntu.name}"
}

output "Ubuntu_image_id" {
  value = "${data.aws_ami.ubuntu.id}"
}

variable "centos-version" {
  type    = string
  default = "Linux 7 x86_64"
  #  default = "Linux 6 x86_64"
}

data "aws_ami" "centos" {
  provider    = aws.east
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["CentOS ${var.centos-version}*"]
  }
}

output "CentOS_image_name" {
  value = "${data.aws_ami.centos.name}"
}

output "CentOS_image_id" {
  value = "${data.aws_ami.centos.id}"
}

variable "amazon-version" {
  type    = string
  default = "2"
}

data "aws_ami" "amazon" {
  provider    = aws.east
  most_recent = true
  #  owners   = ["Canonical"]
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

output "Amazon_image_name" {
  value = "${data.aws_ami.amazon.name}"
}

output "Amazon_image_id" {
  value = "${data.aws_ami.amazon.id}"
}

data "aws_ami" "commvault" {
  provider    = aws.east
  most_recent = true
  #  owners   = ["Canonical"]
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["*Cloud Control*"]
  }
}

output "Commvault_CommServe_image_name" {
  value = "${data.aws_ami.commvault.name}"
}

output "Commvault_CommServe_image_id" {
  value = "${data.aws_ami.amazon.id}"
}

resource "aws_instance" "commserve" {
  provider                    = aws.east
  ami                         = data.aws_ami.commvault.id
  associate_public_ip_address = true
  instance_type               = "m5.xlarge"
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.cmvltRules.id]
  subnet_id                   = aws_subnet.mySubnet.id
  tags = {
    Name        = "TechEnablement test"
    environment = var.environment
    createdby   = var.createdby
  }
}

output "test_instance" {
  value = aws_instance.commserve.public_ip
}
