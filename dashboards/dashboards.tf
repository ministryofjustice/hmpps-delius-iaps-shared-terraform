resource "aws_cloudwatch_dashboard" "iaps" {
  dashboard_name = "iaps"
  dashboard_body = "${data.template_file.iaps_dashboard.rendered}"
  count          = "${var.dashboards_enabled == "true" ? 1:0}"
}
