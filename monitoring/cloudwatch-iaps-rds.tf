# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html

#===========================================================================
# RDS Service
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MonitoringOverview.html#monitoring-cloudwatch
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html
#===========================================================================
resource "aws_cloudwatch_metric_alarm" "iaps_rds_CPUUtilization_warning" {
  alarm_name                = "${var.environment_name}-iaps-rds-CPUUtilization-cwa--warning"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "rds database cpu utilization is greater than 60%"
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = var.iaps_monitoring_rds_db_instance_identifier != "" ? var.iaps_monitoring_rds_db_instance_identifier : data.terraform_remote_state.rds.outputs.rds_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_rds_CPUUtilization_critical" {
  alarm_name                = "${var.environment_name}-iaps-rds-CPUUtilization-cwa--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "90"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "rds database cpu utilization is greater than 90%"
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
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "rds database FreeStorageSpace is less than 20GB"
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = var.iaps_monitoring_rds_db_instance_identifier != "" ? var.iaps_monitoring_rds_db_instance_identifier : data.terraform_remote_state.rds.outputs.rds_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_rds_FreeStorageSpace_critical" {
  alarm_name                = "${var.environment_name}-iaps-rds-FreeStorageSpace-cwa--critical"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "10"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "rds database FreeStorageSpace is less than 10GB"
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = var.iaps_monitoring_rds_db_instance_identifier != "" ? var.iaps_monitoring_rds_db_instance_identifier : data.terraform_remote_state.rds.outputs.rds_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_rds_ReadLatency_warning" {
  alarm_name                = "${var.environment_name}-iaps-rds-ReadLatency-cwa--warning"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "rds database ReadLatency is greater than 1 second"
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = var.iaps_monitoring_rds_db_instance_identifier != "" ? var.iaps_monitoring_rds_db_instance_identifier : data.terraform_remote_state.rds.outputs.rds_db_instance_id
  }
}

