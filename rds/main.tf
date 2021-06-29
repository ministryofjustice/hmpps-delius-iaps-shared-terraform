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

#-------------------------------------------------------------
## Getting the rds db password
#-------------------------------------------------------------
data "aws_ssm_parameter" "db_password" {
  name = "/${local.environment-name}/${local.application}/iaps/iaps/iaps_rds_admin_password"
}

####################################################
# Locals
####################################################

locals {
  vpc_id                 = data.terraform_remote_state.common.outputs.vpc_id
  cidr_block             = data.terraform_remote_state.common.outputs.vpc_cidr_block
  allowed_cidr_block     = [data.terraform_remote_state.common.outputs.vpc_cidr_block]
  internal_domain        = data.terraform_remote_state.common.outputs.internal_domain
  private_zone_id        = data.terraform_remote_state.common.outputs.private_zone_id
  external_domain        = data.terraform_remote_state.common.outputs.external_domain
  public_zone_id         = data.terraform_remote_state.common.outputs.public_zone_id
  common_name            = data.terraform_remote_state.common.outputs.common_name
  environment_identifier = data.terraform_remote_state.common.outputs.environment_identifier
  region                 = var.region
  application            = data.terraform_remote_state.common.outputs.application
  iaps_app_name          = data.terraform_remote_state.common.outputs.iaps_app_name
  dns_name               = "${data.terraform_remote_state.common.outputs.iaps_app_name}-db"
  db_identity            = data.terraform_remote_state.common.outputs.iaps_app_name
  environment            = data.terraform_remote_state.common.outputs.environment
  environment-name       = data.terraform_remote_state.common.outputs.environment_name
  tags                   = merge(var.tags,{"sub-project" = data.terraform_remote_state.common.outputs.iaps_app_name})
  public_cidr_block      = [data.terraform_remote_state.common.outputs.db_cidr_block]
  private_cidr_block     = [data.terraform_remote_state.common.outputs.private_cidr_block]
  db_cidr_block          = [data.terraform_remote_state.common.outputs.db_cidr_block]
  private_subnet_map     = data.terraform_remote_state.common.outputs.private_subnet_map
  db_subnet_ids          = data.terraform_remote_state.common.outputs.db_subnet_ids

  security_group_ids = [
    data.terraform_remote_state.security-groups.outputs.security_groups_sg_rds_id,
    data.terraform_remote_state.security-groups.outputs.security_groups_sg_delius_db,
  ]


  db_password          = data.aws_ssm_parameter.db_password.value
  family               = var.rds_family
  major_engine_version = var.rds_major_engine_version
  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_class
  allocated_storage    = var.rds_allocated_storage
  character_set_name   = var.rds_character_set_name

  enabled_cloudwatch_logs_exports = ["alert", "audit", "listener", "trace"]

  multi_az = var.multi_az

}

############################################
# KMS KEY GENERATION - FOR ENCRYPTION
############################################
module "kms_key" {
  source            = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//kms?ref=terraform-0.12"
  kms_key_name      = local.common_name
  tags              = local.tags
  kms_policy_location = var.environment_type == "prod" ? "policies/kms-cross-account-policy.json" : "policies/kms-policy-${local.environment-name}.json"
}

#-------------------------------------------------------------
### IAM ROLE FOR RDS
#-------------------------------------------------------------

module "rds_monitoring_role" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//iam//role?ref=terraform-0.12"
  rolename   = "${local.common_name}-monitoring"
  policyfile = "rds_monitoring.json"
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  role       = module.rds_monitoring_role.iamrole_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

############################################
# CREATE DB SUBNET GROUP
############################################
module "db_subnet_group" {
  source      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//rds//db_subnet_group?ref=terraform-0.12"
  create      = true
  identifier  = local.common_name
  name_prefix = "${local.common_name}-"
  subnet_ids  = local.db_subnet_ids
  tags        = local.tags
}

############################################
# CREATE PARAMETER GROUP
############################################
module "db_parameter_group" {
  source      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//rds//db_parameter_group?ref=terraform-0.12"
  create      = true
  identifier  = local.common_name
  name_prefix = "${local.common_name}-"
  family      = local.family
  parameters  = var.parameters
  tags        = local.tags
}

resource "aws_db_parameter_group" "iaps_parameter_group" {
  
  name_prefix = "${local.common_name}-"
  description = "Database parameter group for ${local.common_name}"
  family      = local.family

  dynamic "parameter" {
      
    for_each = var.parameters_local
  
    content {
      name  = parameter.key
      value = parameter.value
    }
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

############################################
# CREATE DB OPTIONS
############################################
module "db_option_group" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//rds//db_option_group?ref=terraform-0.12"
  create                   = true
  identifier               = local.common_name
  name_prefix              = "${local.common_name}-"
  option_group_description = "${local.common_name} options group"
  engine_name              = local.engine
  major_engine_version     = local.major_engine_version
  options                  = var.options
  tags                      = local.tags
}

resource "aws_db_option_group" "iaps_option_group" {
  name_prefix              = "${local.common_name}-"
  option_group_description = "${local.common_name} options group" == "" ? format("Option group for %s", local.common_name) : "${local.common_name} options group"
  engine_name              = local.engine
  major_engine_version     = local.major_engine_version
 
  dynamic "option" {

    for_each = var.options_local

    content {
      option_name = option.key
      port = contains(keys(option.value.options), "port") ? option.value.options["port"] : null 
      version = contains(keys(option.value.options), "version") ? option.value.options["version"] : null 
      vpc_security_group_memberships = contains(keys(option.value.options), "vpc_security_group_memberships") ? local.security_group_ids : null 

      dynamic "option_settings" {

        for_each = option.value.settings
        content {
          name = option_settings.key
          value = (contains(["AGENT_REGISTRATION_PASSWORD"],option_settings.key) ? data.aws_ssm_parameter.agent_registration_password.value : option_settings.value)
        }
      }
    }
  }   
  tags = local.tags
}

############################################
# CREATE DB INSTANCE
############################################
module "db_instance" {
  source            = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//rds//db_instance?ref=terraform-0.12"
  create            = true
  identifier        = local.common_name
  engine            = local.engine
  engine_version    = local.engine_version
  instance_class    = local.instance_class
  allocated_storage = local.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = module.kms_key.kms_arn
  license_model     = var.license_model

  name                                = upper(local.db_identity)
  username                            = local.db_identity
  password                            = local.db_password
  port                                = var.port
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  replicate_source_db = var.replicate_source_db

  snapshot_identifier = var.snapshot_identifier

  vpc_security_group_ids = local.security_group_ids

  db_subnet_group_name = module.db_subnet_group.db_subnet_group_id
  parameter_group_name = aws_db_parameter_group.iaps_parameter_group.name
  option_group_name    = aws_db_option_group.iaps_option_group.name
  multi_az             = local.multi_az 
  iops                 = var.iops
  publicly_accessible  = var.publicly_accessible

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = true
  maintenance_window          = var.maintenance_window
  skip_final_snapshot         = var.skip_final_snapshot
  copy_tags_to_snapshot       = var.copy_tags_to_snapshot
  final_snapshot_identifier   = "${local.common_name}-final-snapshot"

  backup_retention_period = var.rds_backup_retention_period
  backup_window           = var.backup_window

  monitoring_interval  = var.rds_monitoring_interval
  monitoring_role_arn  = module.rds_monitoring_role.iamrole_arn
  monitoring_role_name = module.rds_monitoring_role.iamrole_name

  timezone           = var.timezone
  character_set_name = local.character_set_name

  tags = merge(
    local.tags,
    {
      "Name" = "${upper(local.db_identity)}"
    }
  )

  enabled_cloudwatch_logs_exports = local.enabled_cloudwatch_logs_exports
}

###############################################
# Create route53 entry for rds
###############################################

resource "aws_route53_record" "rds_dns_entry" {
  name    = "${local.dns_name}.${local.internal_domain}"
  type    = "CNAME"
  zone_id = local.private_zone_id
  ttl     = 300
  records = [module.db_instance.db_instance_address]
}
