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

variable "priv_subnet_ids" {
  type = "list"
}

variable "vpc_id" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_db_subnet_group" "rds" {
  name        = "${var.target}-${var.stack}${var.sub_stack}-subnet-group-terraform"
  description = "RDS subnet group for ${var.target}-${var.stack}${var.sub_stack}"
  subnet_ids  = ["${var.priv_subnet_ids}"]

  tags {
    Name        = "${var.target}-${var.stack}${var.sub_stack}-subnet-group-terraform"
    Environment = "${var.target}-${var.stack}"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
    SubStack    = "${var.sub_stack}"
  }
}

resource "aws_security_group" "rds_security_group" {
  name        = "${var.target}-${var.stack}${var.sub_stack}-rdssg-terraform"
  description = "SG for RDS access"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.target}-${var.stack}${var.sub_stack}-rdssg-terraform"
    Environment = "${var.target}-${var.stack}"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
    SubStack    = "${var.sub_stack}"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier                  = "${var.target}-${var.stack}${var.sub_stack}-rdsinstance-terraform"
  allocated_storage           = "${var.allocated_storage}"
  engine                      = "${var.engine}"
  instance_class              = "${var.instance_class}"
  name                        = "${var.name}"
  username                    = "${var.username}"
  password                    = "${var.password}"
  multi_az                    = "false"
  db_subnet_group_name        = "${aws_db_subnet_group.rds.id}"
  auto_minor_version_upgrade  = "${var.allow_minor_upgrades}"
  vpc_security_group_ids      = ["${aws_security_group.rds_security_group.id}"]
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
