variable "region" {
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_type" {
  description = "environment"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "ebs_volume_size" {
  default = 50
}

variable "ebs_backup" {
  type = map(string)

  default = {
    schedule           = "cron(0 04 * * ? *)"
    cold_storage_after = 14
    delete_after       = 120
  }
}

variable "environment_name" {
  type = string
}

variable "project_name" {
  description = "The project name - delius-core"
}

variable "psn_proxy_endpoint" {
  description = "PSN Proxies for connecting to IM - Note that there is only 1 PSN proxy and that targets the prod env"
  default     = "localhost"
}

variable "log_retention" {
  description = "Days to keep cloudwatch logs"
  default     = 14
}

variable "iaps_asg_props" {
  type = map(string)
}

variable "iaps_asgv2_props" {
  type = map(string)
}

variable "iaps_asg_suspended_processes" {
  type = list(string)
}

