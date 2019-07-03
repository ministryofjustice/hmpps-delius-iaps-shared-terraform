# primary ec2
output "iaps_asg_arn" {
  value = "${aws_autoscaling_group.iaps.arn}"
}

output "iaps_launchconfig_id" {
  value = "${aws_launch_configuration.iaps.id}"
}

output "iaps_alb_arn" {
  value = "${aws_lb.iaps.arn}"
}

output "iaps_alb_fqdn" {
  value = "${aws_lb.iaps.dns_name}"
}
