variable "geo" {}

variable "region" {}

variable "bucket" {}

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

module "data" {
  source = "../../modules/data"
  region                    = "${var.region}"
  bucket                    = "${var.bucket}"
  geo                       = "${var.geo}"
  target                    = "${var.target}"
  stack                     = "${var.stack}"
  sub_stack                 = "${var.sub_stack}"
  db_size                   = "${var.db_size}"
  db_engine                 = "${var.db_engine}"
  db_instance_class         = "${var.db_instance_class}"
  db_name                   = "${var.db_name}"
  db_user                   = "${var.db_user}"
  db_password               = "${var.db_password}"
  db_storage_type           = "${var.db_storage_type}"
  allow_rds_minor_upgrades  = "${var.allow_rds_minor_upgrades}"
}

output "rds_sg_id" {
  value = "${module.data.rds_sg_id}"
}

output "rds_address" {
  value = "${module.data.rds_address}"
}

output "rds_endpoint" {
  value = "${module.data.rds_endpoint}"
}

output "rds_dbname" {
  value = "${module.data.rds_dbname}"
}

