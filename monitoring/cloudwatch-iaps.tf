resource "aws_cloudwatch_metric_alarm" "iaps_CPUUtilization_warning" {
  alarm_name                = "${var.environment_name}-iaps-CPUUtilization-cwa--warning"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_description         = "This metric monitors ec2 cpu utilization for warning usage"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = "${data.terraform_remote_state.ec2.iaps_asg["arn"]}"
  }

}

resource "aws_cloudwatch_metric_alarm" "iaps_CPUUtilization_critical" {
  alarm_name                = "${var.environment_name}-iaps-CPUUtilization-cwa--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization for critical usage"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = "${data.terraform_remote_state.ec2.iaps_asg["arn"]}"
  }

}

resource "aws_cloudwatch_metric_alarm" "iaps_StatusCheckFailed" {
  alarm_name                = "${var.environment_name}-iaps-StatusCheckFailed--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  alarm_description         = "This metric monitors ec2 StatusCheckFailed"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = "${data.terraform_remote_state.ec2.iaps_asg["arn"]}"
  }

}

resource "aws_cloudwatch_metric_alarm" "iapsv2_CPUUtilization_warning" {
  alarm_name                = "${var.environment_name}-iapsv2-CPUUtilization-cwa--warning"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_description         = "This metric monitors ec2 cpu utilization for warning usage"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = "${data.terraform_remote_state.ec2.iapsv2_asg["arn"]}"
  }

}

resource "aws_cloudwatch_metric_alarm" "iapsv2_CPUUtilization_critical" {
  alarm_name                = "${var.environment_name}-iapsv2-CPUUtilization-cwa--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization for critical usage"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = "${data.terraform_remote_state.ec2.iapsv2_asg["arn"]}"
  }

}

resource "aws_cloudwatch_metric_alarm" "iapsv2_StatusCheckFailed" {
  alarm_name                = "${var.environment_name}-iapsv2-StatusCheckFailed--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  alarm_description         = "This metric monitors ec2 StatusCheckFailed"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = "${data.terraform_remote_state.ec2.iapsv2_asg["arn"]}"
  }

}