variable "geo" {}

variable "region" {}

variable "azs" {}

variable "bucket" {}

variable "target" {}

variable "stack" {}

variable "web_server_count" {}

variable "web_server_ami" {}

variable "web_server_instance_type" {}

variable "key_name" {}

provider "aws" {
  region = "${var.region}"
}

module "application" {
  source = "../../modules/application"
  geo                      = "${var.geo}"
  bucket                   = "${var.bucket}"
  region                   = "${var.region}"
  azs                      = "${var.azs}"
  target                   = "${var.target}"
  stack                    = "${var.stack}"
  web_server_count         = "${var.web_server_count}" 
  web_server_ami           = "${var.web_server_ami}"
  web_server_instance_type = "${var.web_server_instance_type}" 
  key_name                 = "${var.key_name}"         
}