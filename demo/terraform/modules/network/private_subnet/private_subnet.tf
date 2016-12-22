variable "region" {}

variable "target" {}

variable "stack" {}

variable "priv_sub_cidr" {}

variable "vpc_id" {}

variable "igw_id" {}

variable "pub_subnet_id" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_subnet" "private" {
  vpc_id   = "${var.vpc_id}"
  cidr_block    = "${var.priv_sub_cidr}"

  tags {
    Name        = "${var.target}-${var.stack}-priv"
    Stack       = "${var.stack}"
    Target      = "${var.target}"
  }
}

# EIP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat_eip.id}"

  subnet_id = "${var.pub_subnet_id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "${var.target}-${var.stack}-priv-routetable"
    Environment = "${var.target}-${var.stack}"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
  }
}

resource "aws_route_table_association" "priv" {
  subnet_id      = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route" "nat_route" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw.id}"
}

output "priv_subnet_id" {
  value = "${aws_subnet.private.id}"
}

output "nat_gatway_id" {
  value = "${aws_nat_gateway.gw.id}"
}

output "nat_gateway_ip" {
  value = "${aws_eip.nat_eip.id}"
}

output "nat_gateway_cidr" {
  value = "${aws_eip.nat_eip.public_ip}"
}

output "route_table_id" {
  value = "${aws_route_table.private.id}"
}





