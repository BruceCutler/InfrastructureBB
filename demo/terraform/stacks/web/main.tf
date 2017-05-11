variable "geo" {}

variable "region" {}

variable "azs" {
  type = "list"
}

variable "bucket" {}

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

module "web" {
  source = "../../modules/web"
  geo                      = "${var.geo}"
  bucket                   = "${var.bucket}"
  region                   = "${var.region}"
  azs                      = "${var.azs}"
  target                   = "${var.target}"
  stack                    = "${var.stack}"
  sub_stack                = "${var.sub_stack}"
  web_server_count         = "${var.web_server_count}" 
  web_server_ami           = "${var.web_server_ami}"
  web_server_instance_type = "${var.web_server_instance_type}" 
  key_name                 = "${var.key_name}"         
}