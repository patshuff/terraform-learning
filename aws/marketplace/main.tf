provider "aws" {
  version = "> 2"
  profile = "default"
  region  = "us-east-1"
  alias   = "east"
}

variable "createdby" {
  type    = string
  default = "TechEnablement"
}

variable "environment" {
  type    = string
  default = "TechEnablement"
}

variable "key_name" {
  type = string
  default = "cmvlt2019"
}
