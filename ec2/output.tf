output "iaps_launchtemplate_id_v2" {
  value = aws_launch_template.iapsv2.id
}

# output "iaps_asg" {
#   value = {
#     arn  = aws_autoscaling_group.iaps.arn
#     name = aws_autoscaling_group.iaps.name
#   }
# }

output "iapsv2_asg" {
  value = {
    arn  = aws_autoscaling_group.iapsv2.arn
    name = aws_autoscaling_group.iapsv2.name
  }
}

output "iaps_log_group" {
  value = {
    arn               = aws_cloudwatch_log_group.iaps_log_group.arn,
    name              = aws_cloudwatch_log_group.iaps_log_group.name,
    name_prefix       = aws_cloudwatch_log_group.iaps_log_group.name_prefix,
    retention_in_days = aws_cloudwatch_log_group.iaps_log_group.retention_in_days,
    kms_key_id        = aws_cloudwatch_log_group.iaps_log_group.kms_key_id,
    tags              = aws_cloudwatch_log_group.iaps_log_group.tags,
  }
}

output "iaps_log_group_cloudwatch_agent" {
  value = {
    arn               = aws_cloudwatch_log_group.iaps_log_group_cloudwatch_agent.arn,
    name              = aws_cloudwatch_log_group.iaps_log_group_cloudwatch_agent.name,
    name_prefix       = aws_cloudwatch_log_group.iaps_log_group_cloudwatch_agent.name_prefix,
    retention_in_days = aws_cloudwatch_log_group.iaps_log_group_cloudwatch_agent.retention_in_days,
    kms_key_id        = aws_cloudwatch_log_group.iaps_log_group_cloudwatch_agent.kms_key_id,
    tags              = aws_cloudwatch_log_group.iaps_log_group_cloudwatch_agent.tags,
  }
}

output "iaps_log_group_nginx_access" {
  value = {
    arn               = aws_cloudwatch_log_group.iaps_log_group_nginx_access.arn,
    name              = aws_cloudwatch_log_group.iaps_log_group_nginx_access.name,
    name_prefix       = aws_cloudwatch_log_group.iaps_log_group_nginx_access.name_prefix,
    retention_in_days = aws_cloudwatch_log_group.iaps_log_group_nginx_access.retention_in_days,
    kms_key_id        = aws_cloudwatch_log_group.iaps_log_group_nginx_access.kms_key_id,
    tags              = aws_cloudwatch_log_group.iaps_log_group_nginx_access.tags,
  }
}

output "iaps_log_group_nginx_error" {
  value = {
    arn               = aws_cloudwatch_log_group.iaps_log_group_nginx_error.arn,
    name              = aws_cloudwatch_log_group.iaps_log_group_nginx_error.name,
    name_prefix       = aws_cloudwatch_log_group.iaps_log_group_nginx_error.name_prefix,
    retention_in_days = aws_cloudwatch_log_group.iaps_log_group_nginx_error.retention_in_days,
    kms_key_id        = aws_cloudwatch_log_group.iaps_log_group_nginx_error.kms_key_id,
    tags              = aws_cloudwatch_log_group.iaps_log_group_nginx_error.tags,
  }
}

output "iaps_log_group_xmltransfer" {
  value = {
    arn               = aws_cloudwatch_log_group.iaps_log_group_xmltransfer.arn,
    name              = aws_cloudwatch_log_group.iaps_log_group_xmltransfer.name,
    name_prefix       = aws_cloudwatch_log_group.iaps_log_group_xmltransfer.name_prefix,
    retention_in_days = aws_cloudwatch_log_group.iaps_log_group_xmltransfer.retention_in_days,
    kms_key_id        = aws_cloudwatch_log_group.iaps_log_group_xmltransfer.kms_key_id,
    tags              = aws_cloudwatch_log_group.iaps_log_group_xmltransfer.tags,
  }
}

output "iaps_log_group_imiapsif" {
  value = {
    arn               = aws_cloudwatch_log_group.iaps_log_group_imiapsif.arn,
    name              = aws_cloudwatch_log_group.iaps_log_group_imiapsif.name,
    name_prefix       = aws_cloudwatch_log_group.iaps_log_group_imiapsif.name_prefix,
    retention_in_days = aws_cloudwatch_log_group.iaps_log_group_imiapsif.retention_in_days,
    kms_key_id        = aws_cloudwatch_log_group.iaps_log_group_imiapsif.kms_key_id,
    tags              = aws_cloudwatch_log_group.iaps_log_group_imiapsif.tags,
  }
}

output "iaps_log_group_backup" {
  value = {
    arn               = aws_cloudwatch_log_group.iaps_log_group_backup.arn,
    name              = aws_cloudwatch_log_group.iaps_log_group_backup.name,
    name_prefix       = aws_cloudwatch_log_group.iaps_log_group_backup.name_prefix,
    retention_in_days = aws_cloudwatch_log_group.iaps_log_group_backup.retention_in_days,
    kms_key_id        = aws_cloudwatch_log_group.iaps_log_group_backup.kms_key_id,
    tags              = aws_cloudwatch_log_group.iaps_log_group_backup.tags,
  }
}

output "iaps_log_group_system_events" {
  value = {
    arn               = aws_cloudwatch_log_group.iaps_log_group_system_events.arn,
    name              = aws_cloudwatch_log_group.iaps_log_group_system_events.name,
    name_prefix       = aws_cloudwatch_log_group.iaps_log_group_system_events.name_prefix,
    retention_in_days = aws_cloudwatch_log_group.iaps_log_group_system_events.retention_in_days,
    kms_key_id        = aws_cloudwatch_log_group.iaps_log_group_system_events.kms_key_id,
    tags              = aws_cloudwatch_log_group.iaps_log_group_system_events.tags,
  }
}

output "iaps_log_group_application_events" {
  value = {
    arn               = aws_cloudwatch_log_group.iaps_log_group_application_events.arn,
    name              = aws_cloudwatch_log_group.iaps_log_group_application_events.name,
    name_prefix       = aws_cloudwatch_log_group.iaps_log_group_application_events.name_prefix,
    retention_in_days = aws_cloudwatch_log_group.iaps_log_group_application_events.retention_in_days,
    kms_key_id        = aws_cloudwatch_log_group.iaps_log_group_application_events.kms_key_id,
    tags              = aws_cloudwatch_log_group.iaps_log_group_application_events.tags,
  }
}

