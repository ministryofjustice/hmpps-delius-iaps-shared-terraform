####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################
#-------------------------------------------------------------
### Getting current
#-------------------------------------------------------------
data "aws_region" "current" {
}

#-------------------------------------------------------------
### Getting the current running account id
#-------------------------------------------------------------
data "aws_caller_identity" "current" {
}

#-------------------------------------------------------------
### Getting the vpc details
#-------------------------------------------------------------
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the nat gateways details
#-------------------------------------------------------------
data "terraform_remote_state" "nat" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "natgateway/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the monitoring instance details
#-------------------------------------------------------------
data "terraform_remote_state" "monitor" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "shared-monitoring/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the sg details
#-------------------------------------------------------------
data "terraform_remote_state" "security-groups" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "security-groups/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the latest amazon ami
#-------------------------------------------------------------
data "aws_ami" "amazon_ami" {
  most_recent = true

  owners = ["895523100917"]

  filter {
    name   = "name"
    values = ["HMPPS Alfresco master*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

####################################################
# Locals
####################################################

locals {
  account_id                   = data.aws_caller_identity.current.account_id
  vpc_id                       = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block                   = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
  allowed_cidr_block           = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
  internal_domain              = data.terraform_remote_state.vpc.outputs.private_zone_name
  private_zone_id              = data.terraform_remote_state.vpc.outputs.private_zone_id
  external_domain              = data.terraform_remote_state.vpc.outputs.public_zone_name
  public_zone_id               = data.terraform_remote_state.vpc.outputs.public_zone_id
  common_name                  = "${var.environment_identifier}-${var.iaps_app_name}"
  lb_account_id                = var.lb_account_id
  region                       = var.region
  role_arn                     = var.role_arn
  application                  = var.project_name
  iaps_app_name                = var.iaps_app_name
  environment_identifier       = var.environment_identifier
  short_environment_identifier = var.short_environment_identifier
  remote_state_bucket_name     = var.remote_state_bucket_name
  s3_lb_policy_file            = "../policies/s3_alb_policy.json"
  environment                  = var.environment_type
  admin_user                   = "${var.iaps_app_name}${var.environment_type}"
  tags = merge(
    data.terraform_remote_state.vpc.outputs.tags,
    {
      "sub-project" = var.iaps_app_name
    },
    {
      "source-code" = "https://github.com/ministryofjustice/hmpps-delius-iaps-shared-terraform"
    },
  )
  ssh_deployer_key = data.terraform_remote_state.vpc.outputs.ssh_deployer_key

  app_hostnames = {
    internal = "${var.iaps_app_name}-int"
    external = var.iaps_app_name
  }

  sg_map_ids = {
    bastion_in_sg_id       = data.terraform_remote_state.security-groups.outputs.sg_ssh_bastion_in_id
    sg_iaps_api_in         = data.terraform_remote_state.security-groups.outputs.sg_iaps_api_in
    sg_iaps_api_out        = data.terraform_remote_state.security-groups.outputs.sg_iaps_api_out
    sg_iaps_db_in          = data.terraform_remote_state.security-groups.outputs.sg_iaps_db_in
    sg_iaps_external_lb_in = data.terraform_remote_state.security-groups.outputs.sg_iaps_external_lb_in
  }

  private_subnet_map = {
    az1 = data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az1
    az2 = data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az2
    az3 = data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az3
  }

  public_subnet_map = {
    az1 = data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az1
    az2 = data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az2
    az3 = data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az3
  }

  public_cidr_block = [
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az1-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az2-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az3-cidr_block,
  ]

  private_cidr_block = [
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az1-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az2-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az3-cidr_block,
  ]

  db_cidr_block = [
    data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az1-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az2-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az3-cidr_block,
  ]

  db_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az1,
    data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az2,
    data.terraform_remote_state.vpc.outputs.vpc_db-subnet-az3,
  ]

  nat_gateways_ips = [
    "${data.terraform_remote_state.nat.outputs.natgateway_common-nat-public-ip-az1}/32",
    "${data.terraform_remote_state.nat.outputs.natgateway_common-nat-public-ip-az2}/32",
    "${data.terraform_remote_state.nat.outputs.natgateway_common-nat-public-ip-az3}/32",
  ]

  bastion_cidrs = [
    data.terraform_remote_state.vpc.outputs.bastion_vpc_public_cidr["az1"],
    data.terraform_remote_state.vpc.outputs.bastion_vpc_public_cidr["az2"],
    data.terraform_remote_state.vpc.outputs.bastion_vpc_public_cidr["az3"],
  ]
}

#######################################
# SECURITY GROUPS
#######################################
resource "aws_security_group" "vpc-sg-outbound" {
  name        = "${local.common_name}-sg-outbound"
  description = "security group for ${local.common_name}-traffic"
  vpc_id      = local.vpc_id
  tags = merge(
    local.tags,
    {
      "Name" = "${local.common_name}-outbound-traffic"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.vpc-sg-outbound.id
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "${local.common_name}-http"
}

resource "aws_security_group_rule" "https" {
  security_group_id = aws_security_group.vpc-sg-outbound.id
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "${local.common_name}-https"
}

# #-------------------------------------------
# ### S3 bucket for config
# #--------------------------------------------
module "s3config_bucket" {
  # source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//s3bucket//s3bucket_without_policy"
  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//s3bucket//s3bucket_without_policy?ref=terraform-0.12"
  s3_bucket_name = local.common_name
  tags           = local.tags
}

