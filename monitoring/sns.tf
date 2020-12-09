data "aws_sns_topic" "alarm_notification" {
  name = data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_name
}

# resource "aws_sns_topic_subscription" "alarm_subscription" {
#   protocol  = "lambda"
#   topic_arn = "${aws_sns_topic.alarm_notification.arn}"
#   endpoint  = "${aws_lambda_function.notify_slack_alarm.arn}"
# }
