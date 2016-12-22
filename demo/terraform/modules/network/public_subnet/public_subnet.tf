variable "region" {}

variable "target" {}

variable "stack" {}

variable "pub_sub_cidr" {}

variable "vpc_id" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_subnet" "public" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.pub_sub_cidr}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${var.target}-${var.stack}-pub"
    Stack       = "${var.stack}"
    Target      = "${var.target}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "${var.target}-${var.stack}-igw"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "${var.target}-${var.stack}-pub-routetable"
    Environment = "${var.target}-${var.stack}"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route" "igw_route" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}


output "pub_sub_id" {
  value = "${aws_subnet.public.id}"
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "aws_rtb_id" {
  value = "${aws_route_table.public.id}"
}







