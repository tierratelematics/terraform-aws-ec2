/**
 * Required Variables.
 */

variable "project" {
  description = "Name of project"
}

variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
}

variable "name" {
  description = "The service name"
}

variable "vpc_id" {
  description = "VPC ID."
}

variable "vpc_subnets" {
  type        = "list"
  description = "A list of subnet IDs to launch resources in."
}

/**
 * Options.
 */

variable "instance_port" {
  description = "The port on which the load balancer is listening"
  default     = "80"
}

variable "instance_protocol" {
  description = "The protocol to use to the instance. Valid values are HTTP, HTTPS, TCP, or SSL"
  default     = "HTTP"
}

variable "lb_port" {
  description = "The port to listen on for the load balancer"
  default     = "80"
}

variable "lb_protocol" {
  description = "The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL"
  default     = "HTTP"
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  default     = "60"
}

variable "connection_draining" {
  description = "Boolean to enable connection draining."
  default     = false
}

variable "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain."
  default     = "300"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive successful health checks that must occur before declaring an EC2 instance healthy. Valid values: 2 to 10."
  default     = "10"
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive failed health checks that must occur before declaring an EC2 instance unhealthy. Valid values: 2 to 10."
  default     = "2"
}

variable "health_check_timeout" {
  description = "The amount of time to wait when receiving a response from the health check, in seconds. Valid values: 2 to 60."
  default     = "5"
}

variable "health_check_interval" {
  description = "The amount of time between health checks of an individual instance, in seconds. Valid values: 5 to 300"
  default     = "30"
}

variable "health_check_target" {
  description = "The target of the check. Valid pattern is #{PROTOCOL}:#{PORT}#{PATH}, where PROTOCOL values are HTTP, HTTPS - PORT and PATH are required, TCP, SSL - PORT is required, PATH is not supported"
  default     = "HTTP:80/health"
}
