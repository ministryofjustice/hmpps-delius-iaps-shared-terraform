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
### Getting the IAM details
#-------------------------------------------------------------
data "terraform_remote_state" "s3bucket" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "iaps/s3buckets/terraform.tfstate"
    region = "${var.region}"
  }
}

####################################################
# Locals
####################################################

locals {
  region           = "${var.region}"
  iaps_app_name    = "${data.terraform_remote_state.common.iaps_app_name}"
  common_name      = "${data.terraform_remote_state.common.common_name}"
  tags             = "${data.terraform_remote_state.common.common_tags}"
  s3-config-bucket = "${data.terraform_remote_state.common.common_s3-config-bucket}"
}

#-------------------------------------------------------------
### INTERNAL IAM POLICES FOR EC2 RUNNING ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_app_int" {
  template = "${file("../policies/ec2_internal_policy.json")}"

  vars {
    s3-config-bucket = "${local.s3-config-bucket}"
    app_role_arn     = "${module.create-iam-app-role-int.iamrole_arn}"
  }
}

module "create-iam-app-role-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//iam//role"
  rolename   = "${local.common_name}-sim-ec2"
  policyfile = "ec2_policy.json"
}

module "create-iam-instance-profile-int" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//iam//instance_profile"
  role   = "${module.create-iam-app-role-int.iamrole_name}"
}

module "create-iam-app-policy-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//iam//rolepolicy"
  policyfile = "${data.template_file.iam_policy_app_int.rendered}"
  rolename   = "${module.create-iam-app-role-int.iamrole_name}"
}

resource "aws_iam_role_policy_attachment" "iaps_instance_cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = "${module.create-iam-app-role-int.iamrole_name}"
}

resource "aws_iam_role_policy_attachment" "iaps_instance_ssmmgmt_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = "${module.create-iam-app-role-int.iamrole_name}"
}

# AWS Backups IAM role for EFS Data Volume
data "template_file" "backup_assume_role_template" {
  template = "${file("../policies/backup_assume_role.tpl")}"
  vars     = {}
}
resource "aws_iam_role" "iaps_ebs_backup_role" {
  name               = "${local.common_name}-iapsbkup-pri-iam"
  assume_role_policy = "${data.template_file.backup_assume_role_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "iaps_ebs_backup_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = "${aws_iam_role.iaps_ebs_backup_role.name}"
}