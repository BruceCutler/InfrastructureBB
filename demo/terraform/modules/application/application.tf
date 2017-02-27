variable "bucket" {}

variable "geo" {}

variable "region" {}

variable "azs" {}

variable "target" {}

variable "stack" {}

variable "sub_stack" {}

variable "web_server_count" {}

variable "web_server_ami" {}

variable "web_server_instance_type" {}

variable "key_name" {}

provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "networking" {
  backend = "s3"

  config {
    region = "${var.region}"
    bucket = "${var.bucket}"
    key    = "state/${var.target}-networking.tfstate"
  }
}

module "iam" "web_server_iam" {
  source = "./iam"
  region = "${var.region}"
  target = "${var.target}"
  sub_stack = "${var.sub_stack}"
}

module "security" {
  source = "./security"
  region = "${var.region}"
  target = "${var.target}"
  stack  = "${var.stack}"
  sub_stack = "${var.sub_stack}"
  vpc_id = "${data.terraform_remote_state.networking.vpc_id}"
}

module "elb" "web_server_elb" {
  source = "./elb"
  region = "${var.region}"
  target = "${var.target}"
  stack  = "${var.stack}"
  sub_stack = "${var.sub_stack}"
  vpc_id = "${data.terraform_remote_state.networking.vpc_id}"
  elb_subnets = "${data.terraform_remote_state.networking.pub_sub_id}"
}

module "asg" "web_server_asg" {
  source = "./asg"
  region = "${var.region}"
  target = "${var.target}"
  stack  = "${var.stack}"
  sub_stack = "${var.sub_stack}"
  web_server_ami = "${var.web_server_ami}"
  web_server_instance_type = "${var.web_server_instance_type}"
  key_name = "${var.key_name}"
  security_groups = "${module.security.ec2_instance_sg}"
  vpc_zone_identifier = "${data.terraform_remote_state.networking.pub_sub_id}"
  iam_instance_profile = "${module.iam.ec2_iam_profile}"
  elb_id = "${module.elb.web_elb_id}"
}
