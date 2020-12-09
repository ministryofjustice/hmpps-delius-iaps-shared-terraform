####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################
#-------------------------------------------------------------
### Getting the common details
#-------------------------------------------------------------
data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "iaps/common/terraform.tfstate"
    region = var.region
  }
}

data "template_file" "iaps_dashboard" {
  template = file("${path.module}/templates/dashboards/iaps.tpl")

  vars = {
    region           = var.region
    environment_name = var.environment_name
    project_name     = var.project_name
  }
}

data "template_file" "iaps_dashboard_v2" {
  template = file("${path.module}/templates/dashboards/iaps_v2.tpl")

  vars = {
    region           = var.region
    environment_name = var.environment_name
    project_name     = var.project_name
  }
}

