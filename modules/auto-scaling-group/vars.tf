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
// Auto Scaling Group
//

variable "min_size" {
  description = "The maximum size of the auto scale group"
}

variable "max_size" {
  description = "The minimum size of the auto scale group."
}

//
// Launch Configuration
//

variable "ami" {
  description = "The EC2 image ID to launch."
}

//
// VPC
//

variable "vpc_id" {
  description = "VPC ID."
}

/**
 * Optional Variables.
 */

variable "ec2_maintenance_ports" {
  type    = "list"
  default = []
}

variable "ec2_role_tag" {
  description = "Role tag value applied to the EC2 instances created by ASG."
  default     = "ASG"
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with launched instances."
  default     = ""
}

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

variable "load_balancers" {
  type        = "list"
  description = "A list of elastic load balancer names to add to the autoscaling group names."
  default     = []
}

variable "target_group_arns" {
  type        = "list"
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing."
  default     = []
}

variable "instance_type" {
  description = "The size of instance to launch."
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name that should be used for the instance."
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC."
  default     = false
}

variable "user_data" {
  description = "The user data to provide when launching the instance."
  default     = false
}

variable "health_check_type" {
  description = "Controls how health checking is done."
  default     = "ELB"
}

variable "wait_for_elb_capacity" {
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations."
  default     = 2
}

variable "min_elb_capacity" {
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes."
  default     = 2
}

variable "desired_capacity" {
  description = " The number of Amazon EC2 instances that should be running in the group."
  default     = 2
}

variable "health_check_grace_period" {
  description = "Time after instance comes into service before checking health."
  default     = 300
}
