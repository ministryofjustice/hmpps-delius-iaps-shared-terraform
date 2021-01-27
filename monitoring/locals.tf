locals {
  lambda_name_alarm       = "${var.environment_name}-notify-iaps-slack-channel-alarm"
  lambda_name_batch       = "${var.environment_name}-notify-iaps-slack-channel-batch"
  quiet_period_start_hour = "0"
  quiet_period_end_hour   = "3"

  # metrics  
  iaps_nginx_error_log_sum_metric_name = "NginxErrorLogEventSum"
  
  iaps_xmltransfer_log_sum_metric_name = "XMLTransferErrorLogEventSum"
  iaps_imiapsif_log_sum_metric_name    = "IMIAPSIFErrorLogEventSum"

  iaps_cloudwatch_agent_log_sum_metric_name = "CloudwatchAgentErrorLogEventSum"
  iaps_config_backup_log_sum_metric_name    = "ConfigBackupLogEventSum"

}

