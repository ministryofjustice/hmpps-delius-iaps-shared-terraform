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
### Getting the sg details
#-------------------------------------------------------------
data "terraform_remote_state" "security-groups" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "security-groups/terraform.tfstate"
    region = "${var.region}"
  }
}

####################################################
# Locals
####################################################

locals {
  vpc_id                 = "${data.terraform_remote_state.common.vpc_id}"
  cidr_block             = "${data.terraform_remote_state.common.vpc_cidr_block}"
  common_name            = "${data.terraform_remote_state.common.common_name}"
  region                 = "${data.terraform_remote_state.common.region}"
  iaps_app_name          = "${data.terraform_remote_state.common.iaps_app_name}"
  environment_identifier = "${data.terraform_remote_state.common.environment_identifier}"
  environment            = "${data.terraform_remote_state.common.environment}"
  tags                   = "${data.terraform_remote_state.common.common_tags}"
  public_cidr_block      = ["${data.terraform_remote_state.common.db_cidr_block}"]
  private_cidr_block     = ["${data.terraform_remote_state.common.private_cidr_block}"]
  db_cidr_block          = ["${data.terraform_remote_state.common.db_cidr_block}"]
  sg_map_ids             = "${data.terraform_remote_state.common.sg_map_ids}"

  allowed_cidr_block = [
    "${data.terraform_remote_state.common.bastion_vpc_public_cidr}",
    "${var.psn_proxy_cidrs}",
  ]

  bastion_cidr_block  = ["${data.terraform_remote_state.common.bastion_vpc_public_cidr}"]
  internal_inst_sg_id = "${data.terraform_remote_state.common.sg_map_ids["sg_iaps_api_in"]}"
  db_sg_id            = "${data.terraform_remote_state.common.sg_map_ids["sg_iaps_db_in"]}"
  external_lb_sg_id   = "${data.terraform_remote_state.common.sg_map_ids["sg_iaps_external_lb_in"]}"
  sg_delius_db        = "${data.terraform_remote_state.security-groups.sg_mis_out_to_delius_db_id}"
  sg_db_in_from_mis   = "${data.terraform_remote_state.security-groups.sg_delius_core_db_in_from_mis_id}"
}

#######################################
# SECURITY GROUPS
#######################################
#-------------------------------------------------------------
### internal instance sg
#-------------------------------------------------------------
# rdp
resource "aws_security_group_rule" "internal_inst_sg_rdp" {
  security_group_id = "${local.internal_inst_sg_id}"
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["${local.bastion_cidr_block}"]
  description       = "${local.common_name}-remote-access-rdp"
}

resource "aws_security_group_rule" "internal_inst_sg_egress_https" {
  security_group_id = "${local.internal_inst_sg_id}"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks              = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "internal_inst_sg_egress_oracle" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "egress"
  from_port                = "1521"
  to_port                  = "1521"
  protocol                 = "tcp"
  source_security_group_id = "${local.db_sg_id}"
  description              = "${local.common_name}-rds-sg"
}

resource "aws_security_group_rule" "internal_inst_sg_egress_smtp" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "egress"
  from_port                = "25"
  to_port                  = "25"
  protocol                 = "tcp"
  cidr_blocks              = [ "0.0.0.0/0" ]
  description              = "${local.common_name}-smtp-sg"
}

#-------------------------------------------------------------
### rds sg
#-------------------------------------------------------------
resource "aws_security_group_rule" "rds_sg_ingress_oracle" {
  security_group_id        = "${local.db_sg_id}"
  type                     = "ingress"
  from_port                = "1521"
  to_port                  = "1521"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_inst_sg_id}"
  description              = "${local.common_name}-rds-sg"
}

resource "aws_security_group_rule" "rds_sg_ingress_oracle_common" {
  security_group_id        = "${local.db_sg_id}"
  type                     = "ingress"
  from_port                = "1521"
  to_port                  = "1521"
  protocol                 = "tcp"
  source_security_group_id = "${local.sg_delius_db}"
  description              = "${local.common_name}-rds-sg"
}

resource "aws_security_group_rule" "rds_sg_engress_oracle_common" {
  security_group_id        = "${local.sg_delius_db}"
  type                     = "egress"
  from_port                = "1521"
  to_port                  = "1521"
  protocol                 = "tcp"
  source_security_group_id = "${local.db_sg_id}"
  description              = "${local.common_name}-rds-sg"
}
