remote_state {
  backend = "s3"

  config = {
      encrypt        = true
      bucket         = "${get_env("TG_REMOTE_STATE_BUCKET", "REMOTE_STATE_BUCKET")}"
      key            = "iaps/${get_env("TG_ENVIRONMENT_TYPE", "ENVIRONMENT")}/${path_relative_to_include()}/terraform.tfstate"
      region         = "${get_env("TG_REGION", "AWS-REGION")}"
      dynamodb_table = "${get_env("TG_ENVIRONMENT_IDENTIFIER", "ENVIRONMENT_IDENTIFIER")}-lock-table"
    }
  }

  generate = {
    path = "backend.tf"
    if_exists = "skip"
  }
}

terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${get_parent_terragrunt_dir()}/env_configs/${get_env("TG_COMMON_DIRECTORY","common")}/common.tfvars",
      "${get_parent_terragrunt_dir()}/env_configs/${get_env("TG_ENVIRONMENT_NAME", "ENVIRONMENT")}/${get_env("TG_ENVIRONMENT_NAME", "ENVIRONMENT")}.tfvars",
      "${get_parent_terragrunt_dir()}/env_configs/${get_env("TG_ENVIRONMENT_NAME", "ENVIRONMENT")}/sub-projects/iaps.tfvars"
    ]
  }

  extra_arguments "disable_input" {
    commands  = get_terraform_commands_that_need_input()
    arguments = ["-input=false"]
  }
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "${get_env("TG_REGION", "AWS-REGION")}"
  version = "~> 2.70"
}
EOF
}
