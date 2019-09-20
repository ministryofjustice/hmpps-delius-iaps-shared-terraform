variable "region" {}

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
  default = 30
}

variable "ebs_backup" {
  type = "map"

  default = {
    schedule           = "cron(0 04 * * ? *)"
    cold_storage_after = 14
    delete_after       = 120
  }
}

variable "environment_name" {
  type = "string"
}

variable "project_name" {
  description = "The project name - delius-core"
}
