terraform {
  required_version = ">= 0.9, < 0.10"
}

/**
 * Resources.
 */

resource "aws_instance" "bastion" {
  ami                         = "${data.aws_ami.ami.id}"
  source_dest_check           = false
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.vpc_subnet_id}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
  monitoring                  = "${var.monitoring}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${file("${path.module}/user-data.sh")}"

  tags {
    Name        = "${format("%s-%s-%s", var.project, var.environment, var.component)}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.aws_ami_latest_filter}"]
  }

  owners = ["${var.aws_ami_latest_owner}"]
}

resource "aws_security_group" "bastion" {
  name        = "${var.project}-${var.environment}-${var.component}-sg"
  description = "Security group for ASG that allows traffic to the EC2 instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
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
    Name        = "${var.project}-${var.environment}-${var.component}-sg"
    environment = "${var.environment}"
    application = "${var.project}"
  }
}

data "aws_route53_zone" "selected" {
  count = "${var.external_dns_name != "" ? 1 : 0}"

  name         = "${var.external_dns_name}"
}

resource "aws_route53_record" "route53_record" {
  count = "${var.external_dns_name != "" ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.project}-${var.component}.${var.environment}.${var.external_dns_name}"
  type    = "A"

  records = ["${aws_instance.bastion.public_ip}"]
}
