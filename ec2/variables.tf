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

variable "environment_name" {
  type = "string"
}

variable "project_name" {
  description = "The project name - delius-core"
}
