# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instance Type - Instance Sizing"
  type = string
  default = "t2.micro"
}

variable "Environment" {
  description = "Environment name e.g. dev/qa/uat/prod"
  type = string
}