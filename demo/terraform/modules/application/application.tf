variable "bucket" {}

variable "geo" {}

variable "region" {}

variable "azs" {}

variable "target" {}

variable "stack" {}

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

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM Role Policy
resource "aws_iam_role_policy" "ec2_role_policy" {
    name = "ec2_role_policy"
    role = "${aws_iam_role.ec2_role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "ec2_profile"
    roles = ["${aws_iam_role.ec2_role.name}"]
}

# Security Groups For EC2 instances
resource "aws_security_group" "ec2_instances" {
  name = "${var.target}-${var.stack}-sg"
  vpc_id = "${data.terraform_remote_state.networking.vpc_id}"

  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port = 443
    to_port = 443
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

# Launch Config for Web Servers
resource "aws_launch_configuration" "web_server" {
  name = "${var.target}-${var.stack}-web-lc"
  image_id = "${var.web_server_ami}"
  instance_type = "${var.web_server_instance_type}"
  iam_instance_profile   = "${aws_iam_instance_profile.ec2_profile.id}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.ec2_instances.id}"]
  associate_public_ip_address = "true"
}

# ASG for Web Servers
resource "aws_autoscaling_group" "web_servers" {
  name                  = "${var.target}-${var.stack}-web-asg"
  max_size              = 2
  min_size              = 2
  launch_configuration  = "${aws_launch_configuration.web_server.id}"
  vpc_zone_identifier   = ["${data.terraform_remote_state.networking.pub_sub_id}"]
  availability_zones    = ["${var.azs}"]

  tag {
    key                 = "Name"
    value               = "${var.target}-${var.stack}-web"
    propagate_at_launch = true
  }
}
