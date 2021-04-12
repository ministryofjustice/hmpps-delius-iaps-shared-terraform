variable "environment_name" {
  type = string
}

variable "short_environment_name" {
  type = string
}

variable "project_name" {
  description = "The project name - delius-core"
}

variable "project_name_abbreviated" {
  description = "The abbreviated project name, e.g. dat-> delius auto test"
}

variable "environment_type" {
  description = "The environment type - e.g. dev"
}

variable "region" {
  description = "The AWS region."
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_identifier" {
  description = "resource label or name"
}

variable "short_environment_identifier" {
  description = "shortend resource label or name"
}

variable "dependencies_bucket_arn" {
  description = "S3 bucket arn for dependencies"
}

variable "tags" {
  type = map(string)
}

variable "ansible_vars" {
  default = {}
  type    = map(string)
}

variable "default_ansible_vars" {
  default = {}
  type    = map(string)
}

variable "dashboards_enabled" {
  type        = string
  description = "Enable IAPS Cloudwatch Dashboards in the environment"
  default     = "false"
}

variable "iaps_monitoring_rds_db_instance_identifier" {
  type = string
}

variable "deploy_iaps_v1" {
  type = bool
}

variable "account_ids" {
  type = map(string)
}
