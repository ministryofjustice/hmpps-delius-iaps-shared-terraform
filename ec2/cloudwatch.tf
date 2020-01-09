resource "aws_cloudwatch_log_group" "iaps_log_group" {
  name              = "${var.environment_name}/IAPS"
  retention_in_days = "${var.log_retention}"
  tags              = "${merge(local.tags, map("Name", "IAPS"))}"
}
