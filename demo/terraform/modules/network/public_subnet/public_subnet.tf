variable "region" {}

variable "target" {}

variable "stack" {}

variable "pub_sub_cidr" {
  type = "list"
}

variable "vpc_id" {}

variable "azs" {
  type = "list"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_subnet" "public" {
  count                   = "${length(var.pub_sub_cidr)}"
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${element(var.pub_sub_cidr, count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${var.target}-${var.stack}-pub${count.index}-terraform"
    Stack       = "${var.stack}"
    Target      = "${var.target}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "${var.target}-${var.stack}-igw-terraform"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
  }
}

resource "aws_route_table" "public" {
  count          = "${length(var.pub_sub_cidr)}"
  vpc_id         = "${var.vpc_id}"

  tags {
    Name        = "${var.target}-${var.stack}-pubrtb${count.index}-terraform"
    Environment = "${var.target}-${var.stack}"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.pub_sub_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_route" "igw_route" {
  count                  = "${length(var.pub_sub_cidr)}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}


output "pub_sub_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "aws_rtb_id" {
  value = ["${aws_route_table.public.*.id}"]
}
