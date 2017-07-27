/**
 * Resources.
 */

terraform {
  required_version = ">= 0.9, < 0.10"
}

resource "aws_autoscaling_group" "asg" {
  lifecycle {
    create_before_destroy = true
  }

  # spread the app instances across the availability zones
  availability_zones  = "${var.vpc_availability_zones}"
  vpc_zone_identifier = "${var.vpc_subnets}"

  # interpolate the LC into the ASG name so it always forces an update
  name                      = "${var.project}-${var.environment}-${var.name}-asg-with-lc-${aws_launch_configuration.asg-launch-configuration.id}"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  wait_for_elb_capacity     = "${var.wait_for_elb_capacity}"
  desired_capacity          = "${var.desired_capacity}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"
  launch_configuration      = "${aws_launch_configuration.asg-launch-configuration.id}"

  target_group_arns = ["${module.alb.alb_target_group_arn}"]

  tag {
    key                 = "Name"
    value               = "${var.project}-${var.environment}-${var.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "${var.project}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "AMI"
    value               = "${var.ami}"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "asg-launch-configuration" {
  lifecycle {
    create_before_destroy = true
  }

  name_prefix   = "${var.project}-${var.environment}-${var.name}-lc-"
  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.alb-target-port-sg.id}", "${aws_security_group.ec2-maintenance-ports-sg.*.id}"]

  iam_instance_profile = "${var.iam_instance_profile }"

  key_name                    = "${var.key_name}"
  user_data                   = "${var.user_data}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
}

resource "aws_security_group" "alb-target-port-sg" {
  name        = "${var.project}-${var.environment}-asg-${var.name}-alb-port-${var.alb_target_port}"
  description = "Security group for port ${var.alb_target_port} on ASG that allows web traffic inside the VPC"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.alb_target_port}"
    to_port     = "${var.alb_target_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.project}-${var.environment}-asg-${var.name}-alb-port-${var.alb_target_port}"
    environment = "${var.environment}"
    application = "${var.project}"
  }
}

resource "aws_security_group" "ec2-maintenance-ports-sg" {
  count = "${length(var.ec2_maintenance_ports)}"

  name        = "${var.project}-${var.environment}-asg-${var.name}-ec2-maintenance-port-${element(var.ec2_maintenance_ports, count.index)}"
  description = "Security group for port ${element(var.ec2_maintenance_ports, count.index)} on ASG that allows maintenance traffic to the EC2"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${element(var.ec2_maintenance_ports, count.index)}"
    to_port     = "${element(var.ec2_maintenance_ports, count.index)}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.project}-${var.environment}-asg-${var.name}-ec2-maintenance-port-${element(var.ec2_maintenance_ports, count.index)}"
    environment = "${var.environment}"
    application = "${var.project}"
  }
}

module "alb" {
  source = "git::https://github.com/tierratelematics/terraform-aws-ecs.git//modules/alb?ref=0.5.0"

  project     = "${var.project}"
  environment = "${var.environment}"
  name        = "${var.name}"

  security_vpc_id = "${var.vpc_id}"
  subnet_ids      = "${var.vpc_subnets}"

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
  name    = "lb-${var.project}-${var.name}.${var.environment}.${var.external_dns_name}"
  type    = "A"

  weighted_routing_policy {
    weight = 1
  }

  set_identifier = "lb-${var.project}-${var.name}"

  alias {
    name                   = "${module.alb.alb_dns_name}"
    zone_id                = "${module.alb.alb_zone_id}"
    evaluate_target_health = false
  }
}
