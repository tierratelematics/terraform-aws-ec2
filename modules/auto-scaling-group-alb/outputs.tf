/**
 * Outputs.
 */

output "id" {
  value = "${module.auto-scaling-group.id}"
}

output "alb_dns_name" {
  value = "${module.alb.alb_dns_name}"
}
