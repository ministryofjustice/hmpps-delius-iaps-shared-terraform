# KMS Key
output "rds_kms_arn" {
  value = "${module.kms_key.kms_arn}"
}

output "rds_kms_id" {
  value = "${module.kms_key.kms_key_id}"
}

# IAM
output "rds_monitoring_role_arn" {
  value = "${module.rds_monitoring_role.iamrole_arn}"
}

output "rds_monitoring_role_name" {
  value = "${module.rds_monitoring_role.iamrole_name}"
}
