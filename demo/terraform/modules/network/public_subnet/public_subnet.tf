variable "region" {}

variable "target" {}

variable "stack" {}

variable "pub_sub_cidr" {}

variable "vpc_id" {}

variable "azs" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_subnet" "public" {
  count                   = "${length(split(",", var.pub_sub_cidr))}"
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${element(split(",", var.pub_sub_cidr), count.index)}"
  availability_zone       = "${element(split(",", var.azs), count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${var.target}-${var.stack}-pub-${count.index}"
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
  count          = "${length(split(",", var.pub_sub_cidr))}"
  vpc_id         = "${var.vpc_id}"

  tags {
    Name        = "${var.target}-${var.stack}-pub-rtb-${count.index}"
    Environment = "${var.target}-${var.stack}"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(split(",", var.pub_sub_cidr))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_route" "igw_route" {
  count                  = "${length(split(",", var.pub_sub_cidr))}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}


output "pub_sub_ids" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "aws_rtb_id" {
  value = "${join(",", aws_route_table.public.*.id)}"
}
