resource "aws_backup_vault" "iaps_backup_vault" {
  name = "${var.environment_name}-${var.project_name}-iapsabkup-pri-vlt"
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}-${var.project_name}-iapsbkup-pri-vlt"
    },
    {
    "source-code" = "https://github.com/ministryofjustice/hmpps-delius-iaps-shared-terraform"
    },
  )
}

resource "aws_backup_plan" "iaps_backup_plan" {
  name = "${var.environment_name}-${var.project_name}-iapsabkup-pri-pln"

  rule {
    rule_name         = "IAPS EBS Volume Backup"
    target_vault_name = aws_backup_vault.iaps_backup_vault.name
    schedule          = var.ebs_backup["schedule"]

    lifecycle {
      cold_storage_after = var.ebs_backup["cold_storage_after"]
      delete_after       = var.ebs_backup["delete_after"]
    }
  }

  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}-${var.project_name}-iapsbkup-pri-pln"
    },
    {
    "source-code" = "https://github.com/ministryofjustice/hmpps-delius-iaps-shared-terraform"
    },
  )
}

resource "aws_backup_selection" "iaps_backup_selection" {
  iam_role_arn = local.backup_ebs_role_arn
  name         = "${var.environment_name}-${var.project_name}-iapsabkup-pri-sel"
  plan_id      = aws_backup_plan.iaps_backup_plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Name"
    value = "${var.environment_name}-${var.project_name}-iaps-ebs"
  }
}

