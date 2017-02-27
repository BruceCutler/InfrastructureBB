variable "region" {}

variable "target" {}

variable "stack" {}

variable "sub_stack" {}

variable "vpc_id" {}

provider "aws" {
  region = "${var.region}"
}

# Security Groups For EC2 instances
resource "aws_security_group" "ec2_instances" {
  name = "${var.target}-${var.stack}${var.sub_stack}-sg"
  vpc_id = "${var.vpc_id}"

  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.target}-${var.stack}${var.sub_stack}-sg"
  }
}

output "ec2_instance_sg" {
  value = "${aws_security_group.ec2_instances.id}"
}