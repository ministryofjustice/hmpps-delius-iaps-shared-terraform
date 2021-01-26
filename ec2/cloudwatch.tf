resource "aws_cloudwatch_log_group" "iaps_log_group" {
  name              = var.environment_name == "delius-stage" || var.environment_name == "delius-core-dev" ? "${var.environment_name}/IAPS" : "IAPS"
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "IAPS"
    },
  )
}

resource "aws_cloudwatch_log_group" "iaps_log_group_cloudwatch_agent" {
  name              = "${var.environment_name}/IAPS/amazon-cloudwatch-agent.log" 
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/IAPS/amazon-cloudwatch-agent.log"
    },
  )
}

resource "aws_cloudwatch_log_group" "iaps_log_group_nginx_access" {
  name              = "${var.environment_name}/IAPS/access.log" 
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/IAPS/access.log" 
    },
  )
}

resource "aws_cloudwatch_log_group" "iaps_log_group_nginx_error" {
  name              = "${var.environment_name}/IAPS/error.log"
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/IAPS/error.log" 
    },
  )
}

resource "aws_cloudwatch_log_group" "iaps_log_group_xmltransfer" {
  name              = "${var.environment_name}/IAPS/i2n-xmltransfer.log" 
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/IAPS/i2n-xmltransfer.log"
    },
  )
}

resource "aws_cloudwatch_log_group" "iaps_log_group_imiapsif" {
  name              = "${var.environment_name}/IAPS/imiapsif.log" 
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/IAPS/imiapsif.log"
    },
  )
}

resource "aws_cloudwatch_log_group" "iaps_log_group_backup" {
  name              = "${var.environment_name}/IAPS/backup.log" 
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/IAPS/backup.log"
    },
  )
}

resource "aws_cloudwatch_log_group" "iaps_log_group_system_events" {
  name              = "${var.environment_name}/IAPS/system-events" 
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/IAPS/system-events"
    },
  )
}


resource "aws_cloudwatch_log_group" "iaps_log_group_application_events" {
  name              = "${var.environment_name}/IAPS/application-events" 
  retention_in_days = var.log_retention
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}/IAPS/application-events"
    },
  )
}