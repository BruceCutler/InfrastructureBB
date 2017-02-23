variable "region" {}

variable "target" {}

variable "stack" {}

variable "priv_sub_cidr" {}

variable "vpc_id" {}

variable "igw_id" {}

variable "pub_subnet_ids" {}

variable "azs" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_subnet" "private" {
  count             = "${length(split(",", var.priv_sub_cidr))}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(split(",", var.priv_sub_cidr), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"

  tags {
    Name        = "${var.target}-${var.stack}-priv-${count.index}"
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

  subnet_id = "${element(split(",", var.pub_subnet_ids), 0)}"
}

resource "aws_route_table" "private" {
  count          = "${length(split(",", var.priv_sub_cidr))}"
  vpc_id         = "${var.vpc_id}"

  tags {
    Name         = "${var.target}-${var.stack}-priv-rtb-${count.index}"
    Environment  = "${var.target}-${var.stack}"
    Target       = "${var.target}"
    Stack        = "${var.stack}"
  }
}

resource "aws_route_table_association" "priv" {
  count          = "${length(split(",", var.priv_sub_cidr))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route" "nat_route" {
  count                   = "${length(split(",", var.priv_sub_cidr))}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw.id}"
}

output "priv_subnet_id" {
  value = "${join(",", aws_subnet.private.*.id)}"
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
  value = "${join(",", aws_route_table.private.*.id)}"
}





