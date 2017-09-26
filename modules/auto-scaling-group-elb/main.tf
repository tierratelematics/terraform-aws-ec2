terraform {
  required_version = ">= 0.9, < 0.10"
}

/**
 * Resources.
 */

module "auto-scaling-group" {
  source = "../auto-scaling-group"

  project                = "${var.project}"
  environment            = "${var.environment}"
  component              = "${var.component}"
  ami                    = "${var.ami}"
  vpc_id                 = "${var.vpc_id}"
  vpc_availability_zones = "${var.vpc_availability_zones}"
  vpc_subnets            = "${var.vpc_subnets}"
  vpc_security_groups    = "${var.vpc_security_groups}"
  instance_type          = "${var.instance_type}"
  desired_capacity       = "${var.desired_capacity}"
  wait_for_elb_capacity  = "${var.wait_for_elb_capacity}"
  min_elb_capacity       = "${var.min_elb_capacity}"
  min_size               = "${var.min_size}"
  max_size               = "${var.max_size}"
  key_name               = "${var.key_name}"

  associate_public_ip_address = "${var.associate_public_ip_address}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  ec2_maintenance_ports       = ["${var.ec2_maintenance_ports}", "${var.health_check_port}"]
  user_data                   = "${var.user_data}"

  load_balancers = ["${module.elb.elb_name}"]
}

module "elb" {
  source = "../elb"

  project     = "${var.project}"
  environment = "${var.environment}"
  name        = "${var.component}"
  vpc_id      = "${var.vpc_id}"
  vpc_subnets = "${var.vpc_subnets}"

  lb_port                     = "${var.elb_port}"
  lb_protocol                 = "${var.elb_protocol}"
  instance_port               = "${var.elb_target_port}"
  instance_protocol           = "${var.elb_target_protocol}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"

  health_check_target = "${var.health_check_protocol}:${var.health_check_port}${var.health_check_path}"
}

resource "aws_route53_record" "service-alias" {
  zone_id = "${var.external_zone_id}"
  name    = "lb-${var.project}-${var.component}.${var.environment}.${var.external_dns_name}"
  type    = "A"

  weighted_routing_policy {
    weight = 1
  }

  set_identifier = "lb-${var.project}-${var.component}"

  alias {
    name                   = "${module.elb.elb_dns_name}"
    zone_id                = "${module.elb.elb_zone_id}"
    evaluate_target_health = false
  }
}
