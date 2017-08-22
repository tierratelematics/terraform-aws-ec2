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
  vpc_security_group_ids      = ["${aws_security_group.bastion_sg.id}"]
  monitoring                  = "${var.monitoring}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${file("${path.module}/user-data.sh")}"

  tags {
    Name        = "${format("%s-%s-bastion", var.project, var.environment)}"
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

resource "aws_security_group" "bastion_sg" {
  name        = "${var.project}-${terraform.env}-bastion-sg"
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
    Name        = "${var.project}-${terraform.env}-bastion-sg"
    environment = "${terraform.env}"
    application = "${var.project}"
  }
}
