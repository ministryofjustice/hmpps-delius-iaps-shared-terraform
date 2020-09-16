# primary ec2
# output "iaps_asg_arn" {
#   value = "${aws_autoscaling_group.iaps.arn}"
# }

# output "iaps_launchtemplate_id" {
#   value = "${aws_launch_template.iaps.id}"
# }

output "iaps_launchtemplate_id_v2" {
  value = "${aws_launch_template.iapsv2.id}"
}

output "iaps_asg" {
  value = {
    arn = "${aws_autoscaling_group.iaps.arn}"
    name = "${aws_autoscaling_group.iaps.name}"
  }
}

output "iapsv2_asg" {
  value = {
    arn = "${aws_autoscaling_group.iapsv2.arn}"
    name = "${aws_autoscaling_group.iapsv2.name}"
  }
}