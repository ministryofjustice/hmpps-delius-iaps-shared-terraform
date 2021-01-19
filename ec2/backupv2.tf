resource "aws_backup_vault" "iapsv2_backup_vault" {
  name = "${var.environment_name}-${var.project_name}-iapsv2abkup-pri-vlt"
  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}-${var.project_name}-iapsv2bkup-pri-vlt"
    },
  )
}

resource "aws_backup_plan" "iapsv2_backup_plan" {
  name = "${var.environment_name}-${var.project_name}-iapsv2abkup-pri-pln"

  rule {
    rule_name         = "iapsv2 EBS Volume Backup"
    target_vault_name = aws_backup_vault.iapsv2_backup_vault.name
    schedule          = var.ebs_backup["schedule"]

    lifecycle {
      cold_storage_after = var.ebs_backup["cold_storage_after"]
      delete_after       = var.ebs_backup["delete_after"]
    }
  }

  tags = merge(
    local.tags,
    {
      "Name" = "${var.environment_name}-${var.project_name}-iapsv2bkup-pri-pln"
    },
  )
}

resource "aws_backup_selection" "iapsv2_backup_selection" {
  iam_role_arn = local.backup_ebs_role_arn
  name         = "${var.environment_name}-${var.project_name}-iapsv2abkup-pri-sel"
  plan_id      = aws_backup_plan.iapsv2_backup_plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Name"
    value = "${var.environment_name}-${var.project_name}-iapsv2-ebs"
  }
}

