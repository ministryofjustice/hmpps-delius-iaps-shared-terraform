terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 2.70"
}

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

#-------------------------------------------------------------
### Getting the IAM details
#-------------------------------------------------------------
data "terraform_remote_state" "iam" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "iaps/iam/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the security groups details
#-------------------------------------------------------------
data "terraform_remote_state" "security-groups" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "iaps/security-groups/terraform.tfstate"
    region = "${var.region}"
  }
}

# #-------------------------------------------------------------
# ### Getting the latest amazon ami
# #-------------------------------------------------------------
# data "aws_ami" "amazon_ami" {
#   most_recent = true
#   owners      = ["895523100917"]

#   filter {
#     name   = "name"
#     values = ["HMPPS IAPS Windows Server master*"]
#   }

#   # correct arch
#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   # Owned by Amazon
#   filter {
#     name   = "owner-id"
#     values = ["895523100917"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

####################################################
# Locals
####################################################

locals {
  # ami_id                       = "${data.aws_ami.amazon_ami.id}"
  vpc_id                       = "${data.terraform_remote_state.common.vpc_id}"
  internal_domain              = "${data.terraform_remote_state.common.internal_domain}"
  external_domain              = "${data.terraform_remote_state.common.external_domain}"
  public_zone_id               = "${data.terraform_remote_state.common.public_zone_id}"
  short_environment_identifier = "${data.terraform_remote_state.common.short_environment_identifier}"
  application                  = "${data.terraform_remote_state.common.application}"
  environment                  = "${data.terraform_remote_state.common.environment}"
  environment-name             = "${data.terraform_remote_state.common.environment_name}"
  tags                         = "${data.terraform_remote_state.common.common_tags}"
  sg_map_ids                   = "${data.terraform_remote_state.common.sg_map_ids}"
  instance_profile             = "${data.terraform_remote_state.iam.iam_policy_sim_app_instance_profile_name}"
  ssh_deployer_key             = "${data.terraform_remote_state.common.common_ssh_deployer_key}"
  iaps_role                    = "sim-win"
  sg_outbound_id               = "${data.terraform_remote_state.common.common_sg_outbound_id}"
  private_subnet_ids           = ["${data.terraform_remote_state.common.private_subnet_ids}"]
  public_subnet_ids            = ["${data.terraform_remote_state.common.public_subnet_ids}"]
  backup_ebs_role_arn          = "${data.terraform_remote_state.iam.backup_ebs_role_arn}"

}
