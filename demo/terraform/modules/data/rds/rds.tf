variable "geo" {}

variable "region" {}

variable "target" {}

variable "stack" {}

variable "sub_stack" {}

variable "allocated_storage" {}

variable "engine" {}

variable "instance_class" {}

variable "name" {}

variable "username" {}

variable "password" {}

variable "storage_type" {}

variable "allow_minor_upgrades" {}

variable "priv_subnet_ids" {}

variable "vpc_id" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_db_subnet_group" "rds" {
  name        = "${var.target}-${var.stack}${var.sub_stack}-subnet-group"
  description = "RDS subnet group for ${var.target}-${var.stack}${var.sub_stack}"
  subnet_ids  = ["${split(",", var.priv_subnet_ids)}"]

  tags {
    Name        = "${var.target}-${var.stack}${var.sub_stack}-subnet-group"
    Environment = "${var.target}-${var.stack}"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
    SubStack    = "${var.sub_stack}"
  }
}

resource "aws_security_group" "rds_security_group" {
  name        = "${var.target}-${var.stack}-rds-sg"
  description = "SG for RDS access"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.target}-${var.stack}${var.sub_stack}-rds-sg"
    Environment = "${var.target}-${var.stack}"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
    SubStack    = "${var.sub_stack}"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier                  = "${var.target}-${var.stack}${var.sub_stack}-rds"
  allocated_storage           = "${var.allocated_storage}"
  engine                      = "${var.engine}"
  instance_class              = "${var.instance_class}"
  name                        = "${var.name}"
  username                    = "${var.username}"
  password                    = "${var.password}"
  multi_az                    = "true"
  db_subnet_group_name        = "${aws_db_subnet_group.rds.id}"
  auto_minor_version_upgrade  = "${var.allow_minor_upgrades}"
}

output "rds_sg_id" {
  value = "${aws_security_group.rds_security_group.id}"
}

output "rds_address" {
  value = "${aws_db_instance.rds_instance.address}"
}

output "rds_endpoint" {
  value = "${aws_db_instance.rds_instance.endpoint}"
}

output "rds_dbname" {
  value = "${aws_db_instance.rds_instance.name}"
}
