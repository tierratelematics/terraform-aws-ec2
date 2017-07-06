/**
 * Outputs.
 */

output "id" {
  value = "${aws_autoscaling_group.asg.id}"
}

output "alb_dns_name" {
  value = "${module.alb.alb_dns_name}"
}
