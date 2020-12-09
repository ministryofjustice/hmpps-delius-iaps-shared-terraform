# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html

#===========================================================================
# ASG v1
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch.html
#===========================================================================
resource "aws_cloudwatch_metric_alarm" "iaps_asg_CPUUtilization_warning" {
  alarm_name          = "${var.environment_name}-iaps-asg-CPUUtilization-cwa--warning"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors ec2 cpu utilization for warning usage"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iaps_asg["name"]
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_asg_CPUUtilization_critical" {
  alarm_name          = "${var.environment_name}-iaps-asg-CPUUtilization-cwa--critical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors ec2 cpu utilization for critical usage"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iaps_asg["name"]
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_asg_StatusCheckFailed" {
  alarm_name          = "${var.environment_name}-iaps-asg-StatusCheckFailed--critical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors ec2 StatusCheckFailed"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iaps_asg["name"]
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_asg_GroupInServiceInstances" {
  alarm_name          = "${var.environment_name}-iaps-asg-GroupInServiceInstances--critical"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors ec2 GroupInServiceInstances"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iaps_asg["name"]
  }
}

#===========================================================================
# ASG v2
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch.html
#===========================================================================
resource "aws_cloudwatch_metric_alarm" "iapsv2_asg_CPUUtilization_warning" {
  alarm_name          = "${var.environment_name}-iapsv2-asg-CPUUtilization-cwa--warning"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors ec2 cpu utilization for warning usage"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iapsv2_asg["name"]
  }
}

resource "aws_cloudwatch_metric_alarm" "iapsv2_asg_CPUUtilization_critical" {
  alarm_name          = "${var.environment_name}-iapsv2-asg-CPUUtilization-cwa--critical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors ec2 cpu utilization for critical usage"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iapsv2_asg["name"]
  }
}

resource "aws_cloudwatch_metric_alarm" "iapsv2_asg_StatusCheckFailed" {
  alarm_name          = "${var.environment_name}-iapsv2-asg-StatusCheckFailed--critical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors ec2 StatusCheckFailed"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iapsv2_asg["name"]
  }
}

resource "aws_cloudwatch_metric_alarm" "iapsv2_asg_GroupInServiceInstances" {
  alarm_name          = "${var.environment_name}-iapsv2-asg-GroupInServiceInstances--critical"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors ec2 GroupInServiceInstances"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = data.terraform_remote_state.ec2.outputs.iapsv2_asg["name"]
  }
}

#===========================================================================
# RDS Service
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MonitoringOverview.html#monitoring-cloudwatch
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html
#===========================================================================
resource "aws_cloudwatch_metric_alarm" "iaps_rds_CPUUtilization_warning" {
  alarm_name          = "${var.environment_name}-iaps-rds-CPUUtilization-cwa--warning"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors IAPS rds database cpu utilization for warning usage"
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = var.iaps_monitoring_rds_db_instance_identifier != "" ? var.iaps_monitoring_rds_db_instance_identifier : data.terraform_remote_state.rds.outputs.rds_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_rds_CPUUtilization_critical" {
  alarm_name          = "${var.environment_name}-iaps-rds-CPUUtilization-cwa--critical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "120"
  statistic           = "Average"
  threshold           = "90"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors IAPS rds database cpu utilization for critical usage"
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = var.iaps_monitoring_rds_db_instance_identifier != "" ? var.iaps_monitoring_rds_db_instance_identifier : data.terraform_remote_state.rds.outputs.rds_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_rds_FreeStorageSpace_warning" {
  alarm_name                = "${var.environment_name}-iaps-rds-FreeStorageSpace-cwa--warning"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "20"
  alarm_description         = "This metric monitors IAPS rds database FreeStorageSpace for critical usage"
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = var.iaps_monitoring_rds_db_instance_identifier != "" ? var.iaps_monitoring_rds_db_instance_identifier : data.terraform_remote_state.rds.outputs.rds_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_rds_FreeStorageSpace_critical" {
  alarm_name          = "${var.environment_name}-iaps-rds-FreeStorageSpace-cwa--critical"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors IAPS rds database FreeStorageSpace for critical usage"
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = var.iaps_monitoring_rds_db_instance_identifier != "" ? var.iaps_monitoring_rds_db_instance_identifier : data.terraform_remote_state.rds.outputs.rds_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_rds_ReadLatency_warning" {
  alarm_name          = "${var.environment_name}-iaps-rds-ReadLatency-cwa--warning"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "120"
  statistic           = "Average"
  threshold           = "1"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions                = [data.terraform_remote_state.sns.outputs.aws_sns_topic_alarm_notification_arn]
  alarm_description         = "This metric monitors IAPS rds database ReadLatency for warning latency"
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = var.iaps_monitoring_rds_db_instance_identifier != "" ? var.iaps_monitoring_rds_db_instance_identifier : data.terraform_remote_state.rds.outputs.rds_db_instance_id
  }
}

