resource "aws_sns_topic" "iaps_alarm_notification" {
  name = "${var.environment_name}-iaps-alarm-notification"
}

resource "aws_sns_topic_subscription" "iaps_alarm_subscription" {
  protocol  = "lambda"
  topic_arn = aws_sns_topic.iaps_alarm_notification.arn
  endpoint  = aws_lambda_function.notify_slack_alarm.arn
}

output "aws_sns_topic_iaps_alarm_notification" {
  value = {
    id = aws_sns_topic.iaps_alarm_notification.id,
    name = aws_sns_topic.iaps_alarm_notification.name,
    arn = aws_sns_topic.iaps_alarm_notification.arn
  }
}