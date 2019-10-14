####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################
#-------------------------------------------------------------
### Getting the common details
#-------------------------------------------------------------
data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "iaps/common/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the s3 details
#-------------------------------------------------------------
data "terraform_remote_state" "s3bucket" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "iaps/s3buckets/terraform.tfstate"
    region = "${var.region}"
  }
}

data "template_file" "iaps_dashboard" {
  template = "${file("${path.module}/templates/dashboards/iaps.tpl")}"

  vars {
    region           = "${var.region}"
    environment_name = "${var.environment_name}"
    project_name     = "${var.project_name}"
  }
}
