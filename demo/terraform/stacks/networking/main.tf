variable "geo" {}

variable "region" {}

variable "target" {}

variable "stack" {}

variable "vpc_cidr_block" {}

variable "pub_sub_cidr" {}

variable "priv_sub_cidr" {}

provider "aws" {
  region = "${var.region}"
}

module "network" {
  source          = "../../modules/network"
  region          = "${var.region}"
  target          = "${var.target}"
  stack           = "${var.stack}"
  cidr_block      = "${var.vpc_cidr_block}"
  pub_sub_cidr    = "${var.pub_sub_cidr}"
  priv_sub_cidr   = "${var.priv_sub_cidr}"
}

output "vpc_id" {
  value = "${module.network.vpc_id}"
}

output "pub_sub_id" {
  value = "${module.network.pub_sub_id}"
}

output "igw_id" {
  value = "${module.network.igw_id}"
}

output "aws_rtb_id" {
  value = "${module.network.aws_rtb_id}"
}

output "priv_subnet_id" {
  value = "${module.network.priv_subnet_id}"
}

output "nat_gatway_id" {
  value = "${module.network.nat_gatway_id}"
}

output "nat_gateway_ip" {
  value = "${module.network.nat_gateway_ip}"
}

output "nat_gateway_cidr" {
  value = "${module.network.nat_gateway_cidr}"
}

output "priv_route_table_id" {
  value = "${module.network.route_table_id}"
}