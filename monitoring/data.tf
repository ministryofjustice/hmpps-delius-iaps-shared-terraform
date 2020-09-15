data "aws_caller_identity" "current" {
}

# data "template_file" "delius_service_health_dashboard_file" {
#   template = "${file("./templates/cloudwatch/delius-service-health.json")}"
#   vars = {
#     region                       = "${var.region}"
#     # log_group_weblogic_ndelius   = "${data.terraform_remote_state.ndelius.outputs.cloudwatch_log_group}"
#     # log_group_weblogic_interface = "${data.terraform_remote_state.interface.outputs.cloudwatch_log_group}"
#     # log_group_weblogic_spg       = "${data.terraform_remote_state.spg.outputs.cloudwatch_log_group}"
#     # alb_ndelius                  = "${local.ndelius_alb_id}"
#     # asg_ndelius                  = "${data.terraform_remote_state.ndelius.outputs.asg["name"]}"
#     # asg_interface                = "${data.terraform_remote_state.interface.outputs.asg["name"]}"
#     # asg_spg                      = "${data.terraform_remote_state.spg.outputs.asg["name"]}"
#     # asg_ldap                     = "${data.terraform_remote_state.ldap.outputs.asg["name"]}"
#     # instance_delius_db_1         = "${data.terraform_remote_state.db.outputs.ami_delius_db_1}"
#   }
# }

data "template_file" "notify_slack_alarm_lambda_file" {
  template = "${file("${path.module}/templates/lambda/notify-slack-alarm.js")}"
  vars = {
    environment_name        = "${var.environment_name}"
    channel                 = "${var.environment_name == "delius-prod" ? "delius-alerts-deliuscore-production" : "delius-alerts-deliuscore-nonprod"}"
    quiet_period_start_hour = "${local.quiet_period_start_hour}"
    quiet_period_end_hour   = "${local.quiet_period_end_hour}"
  }
}

data "archive_file" "alarm_lambda_handler_zip" {
  type        = "zip"
  output_path = "${"${path.module}/files/${local.lambda_name_alarm}.zip"}"
  source {
    content  = "${data.template_file.notify_slack_alarm_lambda_file.rendered}"
    filename = "notify-slack-alarm.js"
  }
}

data "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
}
