variable "region" {}

variable "target" {}

variable "stack" {}

variable "sub_stack" {}

variable "vpc_zone_identifier" {}

variable "security_groups" {}

variable "web_server_ami" {}

variable "web_server_instance_type" {}

variable "key_name" {}

variable "iam_instance_profile" {}

variable "elb_id" {}

provider "aws" {
  region = "${var.region}"
}

# Launch Config for Web Servers
resource "aws_launch_configuration" "web_server" {
  name                          = "${var.target}-${var.stack}${var.sub_stack}-web-lc"
  image_id                      = "${var.web_server_ami}"
  instance_type                 = "${var.web_server_instance_type}"
  iam_instance_profile          = "${var.iam_instance_profile}"
  key_name                      = "${var.key_name}"
  security_groups               = ["${var.security_groups}"]
  associate_public_ip_address   = "true"
}

# ASG for Web Servers
resource "aws_autoscaling_group" "web_servers" {
  name                  = "${var.target}-${var.stack}${var.sub_stack}-web-asg"
  max_size              = 2
  min_size              = 2
  launch_configuration  = "${aws_launch_configuration.web_server.id}"
  vpc_zone_identifier   = ["${var.vpc_zone_identifier}"]

  tag {
    key                 = "Name"
    value               = "${var.target}-${var.stack}${var.sub_stack}-web"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_elb_attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.web_servers.id}"
  elb                    = "${var.elb_id}"
}

output "web_asg_id" {
  value = "${aws_autoscaling_group.web_servers.id}"
}