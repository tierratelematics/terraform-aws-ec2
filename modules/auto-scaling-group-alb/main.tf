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
  target_group_arns           = ["${module.alb.alb_target_group_arn}"]
}

module "alb" {
  source = "git::https://github.com/tierratelematics/terraform-aws-ecs.git//modules/alb?ref=0.6.0"

  project     = "${var.project}"
  environment = "${var.environment}"
  name        = "${var.component}"

  security_vpc_id = "${var.vpc_id}"
  subnet_ids      = "${var.vpc_subnets}"
  protocol        = "${var.alb_target_protocol}"

  ssl_certificate_arn = "${var.alb_certificate_arn}"
  target_port         = "${var.alb_target_port}"

  health_check_healthy_threshold   = "${var.health_check_healthy_threshold}"
  health_check_unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
  health_check_timeout             = "${var.health_check_timeout}"
  health_check_interval            = "${var.health_check_interval}"
  health_check_path                = "${var.health_check_path}"
  health_check_port                = "${var.health_check_port}"
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
    name                   = "${module.alb.alb_dns_name}"
    zone_id                = "${module.alb.alb_zone_id}"
    evaluate_target_health = false
  }
}
