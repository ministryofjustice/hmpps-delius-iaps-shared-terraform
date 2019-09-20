####################################################
# IAM - Application specific
####################################################
# INTERNAL

# APP ROLE
output "iam_policy_sim_app_role_name" {
  value = "${module.create-iam-app-role-int.iamrole_name}"
}

output "iam_policy_sim_app_role_arn" {
  value = "${module.create-iam-app-role-int.iamrole_arn}"
}

# PROFILE
output "iam_policy_sim_app_instance_profile_name" {
  value = "${module.create-iam-instance-profile-int.iam_instance_name}"
}

output "backup_ebs_role_arn" {
  value = "${aws_iam_role.iaps_ebs_backup_role.arn}"
}