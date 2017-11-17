/**
 * Outputs.
 */

output "id" {
  value = "${aws_instance.instance.id}"
}

output "private_ip" {
  value = "${aws_instance.instance.private_ip}"
}