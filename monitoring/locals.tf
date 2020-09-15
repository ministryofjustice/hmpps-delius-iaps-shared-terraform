locals {
  lambda_name_alarm       = "${var.environment_name}-notify-iaps-slack-channel-alarm"
  lambda_name_batch       = "${var.environment_name}-notify-iaps-slack-channel-batch"
  quiet_period_start_hour = "0"
  quiet_period_end_hour   = "3"
}

