/**
 * Required Variables.
 */

variable "project" {
  description = "Name of project"
}

variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
}

variable "component" {
  description = "The name of component hosted in the Auto Scaling Group"
}

//
// EC2
//

variable "ami_id" {
 description = "AMI ID."
}

/**
 * Optional Variables.
 */

//
// IAM
//

variable "iam_role_name" {
  description = "The IAM role name to associate with EC2 instance(s)."
  default     = ""
}

//
// VPC
//

variable "vpc_security_groups" {
  type        = "list"
  description = "A list of associated security group IDS."
  default     = []
}

variable "vpc_availability_zones" {
  type        = "list"
  description = "A list of AZs to launch resources in. Required only if you do not specify any vpc_public_subnets."
  default     = []
}

variable "vpc_subnets" {
  type        = "list"
  description = "A list of subnet IDs to launch resources in."
  default     = []
}

//
// EC2
//

variable "instance_type" {
  description = "The size of instance to launch."
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name that should be used for the instance."
  default     = ""
}

variable "user_data" {
  description = "The user data to provide when launching the instance."
  default     = false
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC."
  default     = false
}

variable "monitoring" {
  description = " If true, the launched EC2 instance will have detailed monitoring enabled. (Available since v0.6.0)"
  default     = false
}
