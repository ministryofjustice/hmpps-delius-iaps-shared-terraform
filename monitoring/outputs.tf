output "aws_sns_topic_iaps_alarm_notification" {
  value = {
    id = aws_sns_topic.iaps_alarm_notification.id,
    name = aws_sns_topic.iaps_alarm_notification.name,
    arn = aws_sns_topic.iaps_alarm_notification.arn
  }
}