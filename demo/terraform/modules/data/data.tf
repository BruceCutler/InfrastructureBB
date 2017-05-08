variable "bucket" {}

variable "geo" {}

variable "region" {}

variable "target" {}

variable "stack" {}

variable "sub_stack" {}

variable "db_size" {}

variable "db_engine" {}

variable "db_instance_class" {}

variable "db_name" {}

variable "db_user" {}

variable "db_password" {}

variable "db_storage_type" {}

variable "allow_rds_minor_upgrades" {}

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

module "rds" {
  source               = "./rds"
  geo                  = "${var.geo}"
  region               = "${var.region}"
  target               = "${var.target}"
  stack                = "${var.stack}"
  sub_stack            = "${var.sub_stack}"
  allocated_storage    = "${var.db_size}"
  engine               = "${var.db_engine}"
  instance_class       = "${var.db_instance_class}"
  name                 = "${var.db_name}"
  username             = "${var.db_user}"
  password             = "${var.db_password}"
  storage_type         = "${var.db_storage_type}"
  allow_minor_upgrades = "${var.allow_rds_minor_upgrades}"
  priv_subnet_ids      = ["${data.terraform_remote_state.networking.priv_subnet_id}"]
  vpc_id               = "${data.terraform_remote_state.networking.vpc_id}"
}

output "rds_sg_id" {
  value = "${module.rds.rds_sg_id}"
}

output "rds_address" {
  value = "${module.rds.rds_address}"
}

output "rds_endpoint" {
  value = "${module.rds.rds_endpoint}"
}

output "rds_dbname" {
  value = "${module.rds.rds_dbname}"
}



