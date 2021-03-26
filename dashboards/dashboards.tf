resource "aws_cloudwatch_dashboard" "iaps" {
  count = var.deploy_iaps_v1 == false ? 0 : 1
  dashboard_name = "iaps"
  dashboard_body = data.template_file.iaps_dashboard.rendered
}

resource "aws_cloudwatch_dashboard" "iapsv2" {
  dashboard_name = "iapsv2"
  dashboard_body = data.template_file.iaps_dashboard_v2.rendered
}
