
#--------------------------------------------------------------------------------------------------
# c:\ProgramData\Amazon\AmazonCloudWatchAgent\Logs\amazon-cloudwatch-agent.log 
#   -> delius-stage/IAPS/amazon-cloudwatch-agent.log
#--------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "iaps_cloudwatch_agent_log_count" {
  name           = local.iaps_cloudwatch_agent_log_sum_metric_name
  pattern        = ""
  log_group_name = data.terraform_remote_state.ec2.outputs.iaps_log_group_cloudwatch_agent["name"]

  metric_transformation {
    name          = local.iaps_cloudwatch_agent_log_sum_metric_name
    namespace     = "IAPS"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_cloudwatch_agent_log_warning" {
  alarm_name                = "${var.environment_name}-iaps-cloudwatch_agent_log--warning"
  comparison_operator       = "LessThanThreshold"
  period                    = "60"
  evaluation_periods        = "5"
  metric_name               = local.iaps_cloudwatch_agent_log_sum_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "No cloudwatch agent logs for 5 minutes"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

resource "aws_cloudwatch_metric_alarm" "iaps_cloudwatch_agent_log_critical" {
  alarm_name                = "${var.environment_name}-iaps-cloudwatch_agent_log--critical"
  comparison_operator       = "LessThanThreshold"
  period                    = "60"
  evaluation_periods        = "15"
  metric_name               = local.iaps_cloudwatch_agent_log_sum_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "3"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "No cloudwatch agent logs for 15 minutes"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

#--------------------------------------------------------------------------------------------------
# c:\Setup\BackupLogs\backup.log -> delius-stage/IAPS/backup.log
#--------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "iaps_config_backup_log_count" {
  name           = local.iaps_config_backup_log_sum_metric_name
  pattern        = ""
  log_group_name = data.terraform_remote_state.ec2.outputs.iaps_log_group_cloudwatch_agent["name"]

  metric_transformation {
    name          = local.iaps_config_backup_log_sum_metric_name
    namespace     = "IAPS"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_config_backup_log_critical" {
  alarm_name                = "${var.environment_name}-iaps-config_backup_log--critical"
  comparison_operator       = "LessThanThreshold"
  period                    = "3600" 
  evaluation_periods        = "24"   
  metric_name               = local.iaps_config_backup_log_sum_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "10"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "No Config backup logs for today"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

#--------------------------------------------------------------------------------------------------
# c:\nginx\nginx-1.17.6\logs\error.log -> delius-stage/IAPS/error.log
#--------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "iaps_nginx_error_log_count" {
  name           = local.iaps_nginx_error_log_sum_metric_name
  pattern        = "error"
  log_group_name = data.terraform_remote_state.ec2.outputs.iaps_log_group_nginx_error["name"]

  metric_transformation {
    name          = local.iaps_nginx_error_log_sum_metric_name
    namespace     = "IAPS"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_nginx_error_log_warning" {
  alarm_name                = "${var.environment_name}-iaps-nginx_error_log--warning"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  period                    = "60"
  evaluation_periods        = "1"
  metric_name               = local.iaps_nginx_error_log_sum_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "nginx on localhost is reporting a warning number of errors in error.log"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

resource "aws_cloudwatch_metric_alarm" "iaps_nginx_error_log_critical" {
  alarm_name                = "${var.environment_name}-iaps-nginx_error_log--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  period                    = "60"
  evaluation_periods        = "1"
  metric_name               = local.iaps_nginx_error_log_sum_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "3"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "nginx on localhost is reporting a critical number of errors error.log"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = local.tags
}


#--------------------------------------------------------------------------------------------------------------
# C:\Program Files (x86)\I2N\IapsNDeliusInterface\Log\XMLTRANSFER.LOG -> delius-stage/IAPS/i2n-xmltransfer.log
#--------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "iaps_xmltransfer_log_error_count" {
  name           = local.iaps_xmltransfer_log_sum_metric_name
  pattern        = "error"
  log_group_name = data.terraform_remote_state.ec2.outputs.iaps_log_group_xmltransfer["name"]

  metric_transformation {
    name          = local.iaps_xmltransfer_log_sum_metric_name
    namespace     = "IAPS"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_xmltransfer_error_log_warning" {
  alarm_name                = "${var.environment_name}-iaps-xmltransfer_error_log--warning"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  period                    = "60"
  evaluation_periods        = "1"
  metric_name               = local.iaps_xmltransfer_log_sum_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "NDelius Interface is reporting a warning number of errors in i2n-xmltransfer.log"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

resource "aws_cloudwatch_metric_alarm" "iaps_xmltransfer_error_log_critical" {
  alarm_name                = "${var.environment_name}-iaps-xmltransfer_error_log--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  period                    = "60"
  evaluation_periods        = "1"
  metric_name               = local.iaps_xmltransfer_log_sum_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "3"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "NDelius Interface is reporting a critical number of errors i2n-xmltransfer.log"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

resource "aws_cloudwatch_log_metric_filter" "iaps_xmltransfer_log_total_count" {
  name           = local.iaps_xmltransfer_log_sum_total_metric_name
  pattern        = ""
  log_group_name = data.terraform_remote_state.ec2.outputs.iaps_log_group_xmltransfer["name"]

  metric_transformation {
    name          = local.iaps_xmltransfer_log_sum_total_metric_name
    namespace     = "IAPS"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_xmltransfer_no_log_warning" {
  count                     = var.environment_name == "delius-core-dev" ? 0 :1
  alarm_name                = "${var.environment_name}-iaps-xmltransfer_no_log--warning"
  comparison_operator       = "LessThanThreshold"
  period                    = "120"
  evaluation_periods        = "3"
  metric_name               = local.iaps_xmltransfer_log_sum_total_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "NDelius Interface is not sending logs for i2n-xmltransfer.log"
  treat_missing_data        = "breaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

resource "aws_cloudwatch_metric_alarm" "iaps_xmltransfer_no_log_critical" {
  count                     = var.environment_name == "delius-core-dev" ? 0 :1
  alarm_name                = "${var.environment_name}-iaps-xmltransfer_no_log--critical"
  comparison_operator       = "LessThanThreshold"
  period                    = "120"
  evaluation_periods        = "5"
  metric_name               = local.iaps_xmltransfer_log_sum_total_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "NDelius Interface is not sending logs for i2n-xmltransfer.log"
  treat_missing_data        = "breaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

#--------------------------------------------------------------------------------------------------------------
# C:\\Program Files (x86)\\I2N\\IapsIMInterface\\Log\\IMIAPSIF.LOG -> delius-stage/IAPS/imiapsif.log
#--------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "iaps_imiapsif_log_error_count" {
  name           = local.iaps_imiapsif_log_sum_metric_name
  pattern        = "error"
  log_group_name = data.terraform_remote_state.ec2.outputs.iaps_log_group_imiapsif["name"]

  metric_transformation {
    name          = local.iaps_imiapsif_log_sum_metric_name
    namespace     = "IAPS"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_imiapsif_error_log_warning" {
  alarm_name                = "${var.environment_name}-iaps-imiapsif_error_log--warning"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  period                    = "60"
  evaluation_periods        = "1"
  metric_name               = local.iaps_imiapsif_log_sum_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "i2n logs for IM Interface is reporting a warning number of errors in imiapsif.log"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

resource "aws_cloudwatch_metric_alarm" "iaps_imiapsif_error_log_critical" {
  alarm_name                = "${var.environment_name}-iaps-imiapsif_error_log--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  period                    = "60"
  evaluation_periods        = "3"
  metric_name               = local.iaps_imiapsif_log_sum_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "i2n logs for IM Interface is reporting a critical number of errors imiapsif.log"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

resource "aws_cloudwatch_log_metric_filter" "iaps_imiapsif_log_total_count" {
  name           = local.iaps_xmltransfer_log_sum_total_metric_name
  pattern        = ""
  log_group_name = data.terraform_remote_state.ec2.outputs.iaps_log_group_imiapsif["name"]

  metric_transformation {
    name          = local.iaps_imiapsif_log_sum_total_metric_name
    namespace     = "IAPS"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "iaps_imiapsif_no_log_warning" {
  count                     = var.environment_name == "delius-core-dev" ? 0 :1
  alarm_name                = "${var.environment_name}-iaps-imiapsif_no_log--warning"
  comparison_operator       = "LessThanThreshold"
  period                    = "120"
  evaluation_periods        = "3"
  metric_name               = local.iaps_imiapsif_log_sum_total_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "IAPS IM Interface is not sending logs for imiapsif.log"
  treat_missing_data        = "breaching"
  insufficient_data_actions = []
  tags                      = local.tags
}

resource "aws_cloudwatch_metric_alarm" "iaps_imiapsif_no_log_critical" {
  count                     = var.environment_name == "delius-core-dev" ? 0 :1
  alarm_name                = "${var.environment_name}-iaps-imiapsif_no_log--critical"
  comparison_operator       = "LessThanThreshold"
  period                    = "120"
  evaluation_periods        = "5"
  metric_name               = local.iaps_imiapsif_log_sum_total_metric_name
  namespace                 = "IAPS"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.iaps_alarm_notification.arn]
  ok_actions                = [aws_sns_topic.iaps_alarm_notification.arn]
  alarm_description         = "IAPS IM Interface is not sending logs for imiapsif.log"
  treat_missing_data        = "breaching"
  insufficient_data_actions = []
  tags                      = local.tags
}
