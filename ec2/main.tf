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

#-------------------------------------------------------------
### Getting the s3 details
#-------------------------------------------------------------
#data "terraform_remote_state" "s3bucket" {
#  backend = "s3"
#
#  bucket = var.remote_state_bucket_name
#  config = {
#    key    = "iaps/s3buckets/terraform.tfstate"
#    region = var.region
#  }
#}

#-------------------------------------------------------------
### Getting the IAM details
#-------------------------------------------------------------
data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "iaps/iam/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the security groups details
#-------------------------------------------------------------
data "terraform_remote_state" "security-groups" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "iaps/security-groups/terraform.tfstate"
    region = var.region
  }
}

####################################################
# Locals
####################################################

locals {
  # ami_id                       = "${data.aws_ami.amazon_ami.id}"
  vpc_id                       = data.terraform_remote_state.common.outputs.vpc_id
  internal_domain              = data.terraform_remote_state.common.outputs.internal_domain
  external_domain              = data.terraform_remote_state.common.outputs.external_domain
  public_zone_id               = data.terraform_remote_state.common.outputs.public_zone_id
  short_environment_identifier = data.terraform_remote_state.common.outputs.short_environment_identifier
  application                  = data.terraform_remote_state.common.outputs.application
  environment                  = data.terraform_remote_state.common.outputs.environment
  environment-name             = data.terraform_remote_state.common.outputs.environment_name
  tags                         = data.terraform_remote_state.common.outputs.common_tags
  sg_map_ids                   = data.terraform_remote_state.common.outputs.sg_map_ids
  instance_profile             = data.terraform_remote_state.iam.outputs.iam_policy_sim_app_instance_profile_name
  ssh_deployer_key             = data.terraform_remote_state.common.outputs.common_ssh_deployer_key
  iaps_role                    = "sim-win"
  sg_outbound_id               = data.terraform_remote_state.common.outputs.common_sg_outbound_id
  private_subnet_ids           = data.terraform_remote_state.common.outputs.private_subnet_ids
  public_subnet_ids            = data.terraform_remote_state.common.outputs.public_subnet_ids
  backup_ebs_role_arn          = data.terraform_remote_state.iam.outputs.backup_ebs_role_arn
}

