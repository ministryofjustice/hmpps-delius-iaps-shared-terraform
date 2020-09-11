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