resource "aws_lambda_function" "notify_slack_alarm" {
    runtime          = "nodejs12.x"
    role             = data.aws_iam_role.lambda_exec_role.arn
    filename         = data.archive_file.alarm_lambda_handler_zip.output_path
    function_name    = local.lambda_name_alarm
    handler          = "notify-slack-alarm.handler"
    source_code_hash = filebase64sha256(data.archive_file.alarm_lambda_handler_zip.output_path)

    environment {
        variables = {
        ENABLED                 = local.lambda_alarm_enabled,
        QUIET_PERIOD_START_HOUR = local.quiet_period_start_hour,
        QUIET_PERIOD_END_HOUR   = local.quiet_period_end_hour,
        SLACK_CHANNEL           = local.lambda_alarm_slack_channel
        }   
    }

    lifecycle {
        ignore_changes = [
            filename,
            last_modified,
        ]
    }

    tags             = local.tags
}

resource "aws_lambda_permission" "sns_alarm" {
    statement_id  = "AllowExecutionFromSNS"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.notify_slack_alarm.arn
    principal     = "sns.amazonaws.com"
    source_arn    = aws_sns_topic.iaps_alarm_notification.arn
}
