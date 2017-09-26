/**
 * Required Variables.
 */

variable "project" {
  description = "Name of project"
}

variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
}

variable "key_name" {}

variable "vpc_id" {}

variable "vpc_subnet_id" {}

/**
 * Options.
 */

variable "component" {
  default = "bastion"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "external_dns_name" {
  description = "The external DNS (domain) name"
  default = ""
}

//variable "vpc_security_group_ids" {
//  type = "list"
//  default = []
//}

variable "aws_ami_latest_filter" {
  description = "Filter for take the last AWS AMI"
  default     = "amzn-ami-hvm-*-gp2"
}

variable "aws_ami_latest_owner" {
  description = "Owner of the last AWS AMI"
  default     = "amazon"
}

variable "monitoring" {
  default = false
}

variable "associate_public_ip_address" {
  default = true
}
