terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
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

#-------------------------------------------------------------
## Getting the rds db password
#-------------------------------------------------------------
data "aws_ssm_parameter" "db_password" {
  name = "${data.terraform_remote_state.common.common_name}-rds-db-password"
}

####################################################
# Locals
####################################################

locals {
  vpc_id                 = "${data.terraform_remote_state.common.vpc_id}"
  cidr_block             = "${data.terraform_remote_state.common.vpc_cidr_block}"
  allowed_cidr_block     = ["${data.terraform_remote_state.common.vpc_cidr_block}"]
  internal_domain        = "${data.terraform_remote_state.common.internal_domain}"
  private_zone_id        = "${data.terraform_remote_state.common.private_zone_id}"
  external_domain        = "${data.terraform_remote_state.common.external_domain}"
  public_zone_id         = "${data.terraform_remote_state.common.public_zone_id}"
  common_name            = "${data.terraform_remote_state.common.common_name}"
  environment_identifier = "${data.terraform_remote_state.common.environment_identifier}"
  region                 = "${var.region}"
  iaps_app_name          = "${data.terraform_remote_state.common.iaps_app_name}"
  environment            = "${data.terraform_remote_state.common.environment}"
  tags                   = "${data.terraform_remote_state.common.common_tags}"
  public_cidr_block      = ["${data.terraform_remote_state.common.db_cidr_block}"]
  private_cidr_block     = ["${data.terraform_remote_state.common.private_cidr_block}"]
  db_cidr_block          = ["${data.terraform_remote_state.common.db_cidr_block}"]
  private_subnet_map     = "${data.terraform_remote_state.common.private_subnet_map}"
  db_subnet_ids          = ["${data.terraform_remote_state.common.db_subnet_ids}"]
  security_group_ids     = ["${data.terraform_remote_state.security-groups.security_groups_sg_rds_id}"]
  db_password            = "${data.aws_ssm_parameter.db_password.value}"
}

############################################
# KMS KEY GENERATION - FOR ENCRYPTION
############################################

module "kms_key" {
  source       = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//kms"
  kms_key_name = "${local.common_name}"
  tags         = "${local.tags}"
}

#-------------------------------------------------------------
### IAM ROLE FOR RDS
#-------------------------------------------------------------

module "rds_monitoring_role" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//iam//role"
  rolename   = "${local.common_name}-monitoring"
  policyfile = "rds_monitoring.json"
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  role       = "${module.rds_monitoring_role.iamrole_name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
