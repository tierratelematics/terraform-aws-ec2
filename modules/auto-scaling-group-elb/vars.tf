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
// Route 53
//

variable "external_zone_id" {}

variable "external_dns_name" {}

//
// VPC
//

variable "vpc_id" {
  description = "VPC ID."
}

variable "elb_port" {
  description = "The port to listen on for the load balancer."
}

variable "elb_protocol" {
  description = "The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL"
}

variable "elb_target_port" {
  description = "The port on the instance to route to."
}

variable "elb_target_protocol" {
  description = "Protocol on the EC2 that will be exposed using the Classic Load Balancer. Valid values are HTTP, HTTPS, TCP, or SSL"
}

/**
 * Optional Variables.
 */

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

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  default     = 60
}

variable "connection_draining" {
  description = "Boolean to enable connection draining."
  default     = false
}

variable "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain."
  default     = 300
}

variable "instance_type" {
  description = "The size of instance to launch."
  default     = "t2.micro"
}

variable "ec2_maintenance_ports" {
  type    = "list"
  default = []
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

//
// Capacity
//

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

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  default     = "10m"
}

//
// Health check
//

variable "health_check_type" {
  description = "Controls how health checking is done."
  default     = "ELB"
}

variable "health_check_grace_period" {
  description = "Time after instance comes into service before checking health."
  default     = 300
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy."
  default     = "3"
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering the target unhealthy."
  default     = "2"
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check."
  default     = "5"
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds."
  default     = "15"
}

variable "health_check_protocol" {
  description = "The protocol for the health check request."
  default     = "HTTP"
}

variable "health_check_path" {
  description = "The destination for the health check request."
  default     = "/health"
}

variable "health_check_port" {
  description = "The port for the health check request."
  default     = "80"
}
