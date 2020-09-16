terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 2.17"
}

####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################
#-------------------------------------------------------------
### Getting the sns topic details
#-------------------------------------------------------------
data "terraform_remote_state" "sns" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "delius-core/monitoring/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the ec2 topic details
#-------------------------------------------------------------
data "terraform_remote_state" "ec2" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "iaps/ec2/terraform.tfstate"
    region = "${var.region}"
  }
}


#-------------------------------------------------------------
### Getting the rds instance details
#-------------------------------------------------------------
data "terraform_remote_state" "rds" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "iaps/rds/terraform.tfstate"
    region = "${var.region}"
  }
}