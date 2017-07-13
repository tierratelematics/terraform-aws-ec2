# terraform-aws-ec2

This repository is a set of Terraform modules for building infrastructure with AWS EC2.

## Quickstart

The easiest way to get the modules and running is by creating a Terraform definition for it, copy this snippet in a file
named `main.tf`:

```hcl
module "auto-scaling-group" {
  source = "git::https://github.com/tierratelematics/terraform-aws-ec2.git//modules/auto-scaling-group?ref=0.2.0"

  project                     = "${var.project}"
  environment                 = "${terraform.env}"
  name                        = "backend"
  ami                         = "${data.aws_ami.version.id}"
  
  vpc_id                      = "${var.vpc_id}"
  vpc_availability_zones      = "${var.vpc_availability_zones}"
  vpc_subnets                 = "${var.vpc_subnets}"
  
  instance_type               = "${var.instance_type}"
  desired_capacity            = "${var.desired_capacity}"
  min_size                    = "${var.min_size}"
  max_size                    = "${var.max_size}"

  associate_public_ip_address = "${var.associate_public_ip_address}"

  alb_target_port             = "8080"
  alb_certificate_arn         = "${var.alb_certificate_arn}"
}
```

## IAM Instance Profile

If you instance access AWS service you cou can specify an instance profile using the parameter `iam_instance_profile`.

```hcl
module "auto-scaling-group" {
  source = "git::https://github.com/tierratelematics/terraform-aws-ec2.git//modules/auto-scaling-group?ref=0.2.0"

  project                     = "${var.project}"
  environment                 = "${terraform.env}"
  ...

  iam_instance_profile        = "${aws_iam_instance_profile.backend-asg-profile.name}"
}

resource "aws_iam_instance_profile" "backend-asg-profile" {
  name = "${var.project}-${var.environment}-backend-asg-profile"
  role = "${module.asg-server-role.role_name}"
}

module "asg-server-role" {
  source = "git::https://github.com/tierratelematics/terraform-aws-iam.git///modules/iam/role"
  
  ...
}
```

If you need a Terraform module to build a IAM Role checkout https://github.com/tierratelematics/terraform-aws-iam.


## User Data

You can also specify a custom `user_data` parameter, using the handy `template_file` _data source_.

```hcl
module "auto-scaling-group" {
  source = "git::https://github.com/tierratelematics/terraform-aws-ec2.git//modules/auto-scaling-group?ref=0.2.0"

  project                     = "${var.project}"
  environment                 = "${terraform.env}"
  ...

  user_data = "${data.template_file.user-data.rendered}"
}

data "template_file" "user-data" {
  template = "${file("services/backend/user-data.sh")}"

  vars {
    project     = "${var.project}"
    environment = "${var.environment}"

    ...

    redis_host = "${var.redis["host"]}"
    redis_port = "${var.redis["port"]}"
  }
}
```

## Maintenance Ports

If you need to expose some ports to access maintenance services use the `ec2_maintenance_ports` parameter.

```hcl
module "auto-scaling-group" {
  source = "git::https://github.com/tierratelematics/terraform-aws-ec2.git//modules/auto-scaling-group?ref=0.2.0"

  project                     = "${var.project}"
  environment                 = "${terraform.env}"
  ...

  ec2_maintenance_ports       = [22, 2551, 8551]
}
```

## License

Copyright 2017 Tierra SpA

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
