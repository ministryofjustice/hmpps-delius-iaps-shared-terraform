# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html


#===========================================================================
# ASG v2
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch.html
#===========================================================================
resource "aws_cloudwatch_metric_alarm" "iapsv2_asg_CPUUtilization_warning" {
  alarm_name                = "${var.environment_name}-iapsv2-asg-CPUUtilization-cwa--warning"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "ec2 cpu utilization for the IAPS v2 ASG is greater than 60%"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iapsv2_asg["name"]
  }
}

resource "aws_cloudwatch_metric_alarm" "iapsv2_asg_CPUUtilization_critical" {
  alarm_name                = "${var.environment_name}-iapsv2-asg-CPUUtilization-cwa--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "ec2 cpu utilization for the IAPS v2 ASG is greater than 80%"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iapsv2_asg["name"]
  }
}

resource "aws_cloudwatch_metric_alarm" "iapsv2_asg_StatusCheckFailed" {
  alarm_name                = "${var.environment_name}-iapsv2-asg-StatusCheckFailed--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "ec2 StatusCheckFailed for one or more instances in the IAPS v2 ASG"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iapsv2_asg["name"]
  }
}

resource "aws_cloudwatch_metric_alarm" "iapsv2_asg_GroupInServiceInstances" {
  alarm_name                = "${var.environment_name}-iapsv2-asg-GroupInServiceInstances--critical"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "GroupInServiceInstances"
  namespace                 = "AWS/AutoScaling"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "There is less than 1 instance InService for ec2 IAPS ASG"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iapsv2_asg["name"]
  }
}
