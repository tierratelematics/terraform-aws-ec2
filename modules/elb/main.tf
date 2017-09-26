/**
 * Resources.
 */

resource "aws_elb" "elb" {
  name            = "${var.project}-${var.environment}-${var.name}-elb"
  subnets         = "${var.vpc_subnets}"
  security_groups = ["${aws_security_group.elb_security_group.id}"]

  listener {
    instance_port     = "${var.instance_port}"
    instance_protocol = "${var.instance_protocol}"
    lb_port           = "${var.lb_port}"
    lb_protocol       = "${var.lb_protocol}"
  }

  health_check {
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    timeout             = "${var.health_check_timeout}"
    target              = "${var.health_check_target}"
    interval            = "${var.health_check_interval}"
  }

  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"

  tags {
    Name       = "${var.project}-${var.environment}-${var.name}-tg"
    Project    = "${var.project}"
    Deployment = "${var.environment}"
  }
}

resource "aws_security_group" "elb_security_group" {
  name        = "${var.project}-${var.environment}-sg-${var.name}-lb"
  description = "${var.name} load balancer security group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.lb_port}"
    to_port     = "${var.lb_port}"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
