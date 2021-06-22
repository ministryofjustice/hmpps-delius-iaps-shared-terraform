provider "aws" {
  alias   = "engineering"
  region  = var.region
  version = "~> 2.70"

  assume_role {
    role_arn = var.eng_role_arn
  }
}

# eng_role_arn points to non-engineering role in both common and common-prod environment configs
# Lucklily agent registration password is the same for development and production
# Therefore we can use the name below

data "aws_ssm_parameter" "agent_registration_password" {
  provider = aws.engineering
  name     = "/engineering-dev/engineering/oem-database/db/agent_registration_password"
} 

resource "random_password" "dbsnmp_password" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "dbsnmp_password" {
  name        = "/${local.environment-name}/${local.application}/iaps/iaps/dbsnmp_password" 
  description = "OEM Agent Registration Password"
  type        = "SecureString"
  value       = random_password.dbsnmp_password.result

  tags = local.tags

  lifecycle {
    ignore_changes = [value]
  }
}