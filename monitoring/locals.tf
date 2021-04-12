locals {
  # lambda slack alerting
  lambda_name_alarm          = "${var.environment_name}-notify-iaps-slack-channel-alarm"
  lambda_alarm_enabled       = true
  lambda_alarm_slack_channel = var.environment_name == "delius-prod" ? "delius-alerts-iaps-production" : "delius-alerts-iaps-nonprod"
  quiet_period_start_hour    = "0"
  quiet_period_end_hour      = "6"

  # metrics  
  iaps_nginx_error_log_sum_metric_name       = "IAPSNginxErrorLogEventSum"
  
  #nDelius Interface Log
  iaps_xmltransfer_log_sum_metric_name       = "IAPSXMLTransferErrorLogEventSum"
  iaps_xmltransfer_log_sum_total_metric_name = "IAPSXMLTransferTotalLogEventSum"
  
  #IM Interface Log
  iaps_imiapsif_log_sum_metric_name          = "IAPSIMIAPSIFErrorLogEventSum"
  iaps_imiapsif_log_sum_total_metric_name    = "IAPSIMIAPSIFTotalLogEventSum"
  
  # Cloudwatch agent log
  iaps_cloudwatch_agent_log_sum_metric_name  = "IAPSCloudwatchAgentErrorLogEventSum"
  
  #Daily IM Config backup Log
  iaps_config_backup_log_sum_metric_name     = "IAPSConfigBackupLogEventSum"

  tags = var.tags

  environment_name = var.environment_name
  
  iaps_account_ids = {
    delius-core-dev = "723123699647"
    delius-stage    = "205048117103"
    delius-prod     = "050243167760"
  }

  # Slack alarms
  slack_nonprod_url     = "/services/T02DYEB3A/BS16X2JGY/r9e1CJYez7BDmwyliIl7WzLf"
  slack_nonprod_channel = "delius-alerts-iaps-nonprod"
  slack_prod_url        = "/services/T02DYEB3A/BRU7E5QSC/3Rt4FV9FtrDSll5aMPABgRoB"
  slack_prod_channel    = "delius-alerts-iaps-production"
}
