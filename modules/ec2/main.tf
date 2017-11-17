terraform {
  required_version = ">= 0.9"
}

/**
 * Resources.
 */

resource "aws_instance" "instance" {
  ami = "${var.ami_id}"

  source_dest_check = false
  instance_type     = "${var.instance_type}"

  subnet_id              = "${element(var.vpc_subnets, 0)}"            // TODO: this may work, but.. it's the best strategy?
  availability_zone      = "${element(var.vpc_availability_zones, 0)}"
  vpc_security_group_ids = ["${var.vpc_security_groups}"]

  key_name                    = "${var.key_name}"
  monitoring                  = "${var.monitoring}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.user_data}"

  iam_instance_profile = "${aws_iam_instance_profile.instance-profile.name}"

  tags {
    Name        = "${format("%s-%s-%s", var.project, var.environment, var.component)}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Component   = "${var.component}"
  }
}

// data "aws_ami" "ami" {
//   most_recent = true

//   filter {
//     name   = "name"
//     values = ["${var.project}-${var.component}-*"]
//   }

//   filter {
//     name   = "state"
//     values = ["available"]
//   }

//   filter {
//     name = "tag:ModuleVersion"

//     values = [
//       "${var.component_version == "latest" ? "*" : format("*%s", var.component_version)}",
//     ]
//   }

//   owners = ["self"]
// }

resource "aws_iam_instance_profile" "instance-profile" {
  name = "${var.project}-${terraform.env}-${var.component}-profile"
  role = "${var.iam_role_name}"
}
