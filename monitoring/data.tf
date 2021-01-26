data "aws_caller_identity" "current" {
}

data "template_file" "notify_slack_alarm_lambda_file" {
  template = file("${path.module}/templates/lambda/notify-slack-alarm.js")
  vars = {
    environment_name        = var.environment_name
    channel                 = var.environment_name == "delius-prod" ? "delius-alerts-iaps-production" : "delius-alerts-iaps-nonprod"
    quiet_period_start_hour = local.quiet_period_start_hour
    quiet_period_end_hour   = local.quiet_period_end_hour
  }
}

data "archive_file" "alarm_lambda_handler_zip" {
  type        = "zip"
  output_path = "${path.module}/files/${local.lambda_name_alarm}.zip"
  source {
    content  = data.template_file.notify_slack_alarm_lambda_file.rendered
    filename = "notify-slack-alarm.js"
  }
}

data "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
}

