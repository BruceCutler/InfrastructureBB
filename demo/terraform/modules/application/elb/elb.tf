variable "region" {}

variable "target" {}

variable "stack" {}

variable "vpc_id" {}

variable "elb_subnets" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "elb_security_group" {
  name = "${var.target}-${var.stack}-elb-sg"
  vpc_id = "${var.vpc_id}"

  ingress = {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.target}-${var.stack}-sg"
  }
}

resource "aws_elb" "web_elb" {
  name = "${var.target}-${var.stack}-web-elb"
  cross_zone_load_balancing = "true"
  internal = "false"
  subnets = ["${split(",",var.elb_subnets)}"]
  security_groups = ["${aws_security_group.elb_security_group.id}"]
  connection_draining = "true"

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  tags {
    Name        = "${var.target}-${var.stack}-elb"
    Environment = "${var.target}-${var.stack}"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
  }
}

output "web_elb_id" {
  value = "${aws_elb.web_elb.id}"
}

