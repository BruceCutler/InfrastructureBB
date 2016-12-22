variable "region" {}

variable "target" {}

variable "stack" {}

variable "cidr_block" {}

variable "pub_sub_cidr" {}

variable "priv_sub_cidr" {}

provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source       = "./vpc"
  region       = "${var.region}"
  target       = "${var.target}"
  stack        = "${var.stack}"
  cidr_block   = "${var.cidr_block}"
}

module "public_subnet" {
  source         = "./public_subnet"
  region         = "${var.region}"
  target         = "${var.target}"
  stack          = "${var.stack}"
  pub_sub_cidr   = "${var.pub_sub_cidr}"
  vpc_id         = "${module.vpc.vpc_id}"
}

module "private_subnet" {
  source          = "./private_subnet"
  region          = "${var.region}"
  target          = "${var.target}"
  stack           = "${var.stack}"
  priv_sub_cidr   = "${var.priv_sub_cidr}"
  vpc_id          = "${module.vpc.vpc_id}"
  igw_id          = "${module.public_subnet.igw_id}"
  pub_subnet_id  = "${module.public_subnet.pub_sub_id}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "pub_sub_id" {
  value = "${module.public_subnet.pub_sub_id}"
}

output "igw_id" {
  value = "${module.public_subnet.igw_id}"
}

output "aws_rtb_id" {
  value = "${module.public_subnet.aws_rtb_id}"
}

output "priv_subnet_id" {
  value = "${module.private_subnet.priv_subnet_id}"
}

output "nat_gatway_id" {
  value = "${module.private_subnet.nat_gatway_id}"
}

output "nat_gateway_ip" {
  value = "${module.private_subnet.nat_gateway_ip}"
}

output "nat_gateway_cidr" {
  value = "${module.private_subnet.nat_gateway_cidr}"
}

output "route_table_id" {
  value = "${module.private_subnet.route_table_id}"
}


















