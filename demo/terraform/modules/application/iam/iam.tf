variable "region" {}

variable "target" {}

provider "aws" {
  region = "${var.region}"
}

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "${var.target}_ec2_role"
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
    name = "${var.target}_ec2_profile"
    roles = ["${aws_iam_role.ec2_role.name}"]
}

output "ec2_iam_profile" {
  value = "${aws_iam_instance_profile.ec2_profile.id}"
}