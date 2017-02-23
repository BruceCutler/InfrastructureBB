variable "region" {}

variable "target" {}

variable "stack" {}

variable "cidr_block" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_block}"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags {
    Name   = "vpc-${var.target}-${var.stack}"
    Target = "${var.target}"
  }
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}