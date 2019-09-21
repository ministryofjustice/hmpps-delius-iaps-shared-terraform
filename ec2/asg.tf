data "template_file" "instance_userdata" {
  template = "${file("../userdata/userdata.txt")}"

  vars {
    host_name         = "${local.iaps_role}-001"
    internal_domain   = "${local.internal_domain}"
    external_domain   = "${local.external_domain}"
    user_ssm_path     = "/${local.environment-name}/${local.application}/iaps/iaps/iaps_user"
    password_ssm_path = "/${local.environment-name}/${local.application}/iaps/iaps/iaps_password"
    psn_proxy_endpoint = "${var.psn_proxy_endpoint}"
  }
}

resource "aws_launch_template" "iaps" {
  name_prefix = "${local.environment-name}-${local.application}-iaps-pri-tpl-"
  description = "Windows IAPS Server Launch Template"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_type = "gp2"
      volume_size = "${var.ebs_volume_size}"
    }
  }

  ebs_optimized = true

  iam_instance_profile {
    name = "${local.instance_profile}"
  }

  image_id      = "${local.ami_id}"
  instance_type = "${var.instance_type}"

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false

    security_groups = [
      "${local.sg_map_ids["sg_iaps_api_in"]}",
      "${local.sg_outbound_id}",
    ]
  }

  user_data = "${base64encode(data.template_file.instance_userdata.rendered)}"

  tag_specifications {
    resource_type = "instance"
    tags          = "${merge(local.tags, map("Name", "${var.environment_name}-${var.project_name}-iaps-ec2"))}"
  }

  tag_specifications {
    resource_type = "volume"
    tags          = "${merge(local.tags, map("Name", "${var.environment_name}-${var.project_name}-iaps-ebs"))}"
  }
}

# Hack to merge additional tag into existing map and convert to list for use with asg tags input
data "null_data_source" "asg-tags" {
  count = "${length(keys(merge(local.tags, map("Name", "${local.environment-name}-${var.project_name}-iaps-asg"))))}"

  inputs = {
    key                 = "${element(keys(merge(local.tags, map("Name", "${local.environment-name}-${var.project_name}-iaps-asg"))), count.index)}"
    value               = "${element(values(merge(local.tags, map("Name", "${local.environment-name}-${var.project_name}-iaps-asg"))), count.index)}"
    propagate_at_launch = "true"
  }
}

resource "aws_autoscaling_group" "iaps" {
  name = "${local.environment-name}-${local.application}-iaps-asg"

  vpc_zone_identifier = ["${local.private_subnet_ids}"]

  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"

  #launch_configuration      = "${aws_launch_configuration.iaps.name}"
  launch_template = {
    id      = "${aws_launch_template.iaps.id}"
    version = "$Latest"
  }

  target_group_arns = [
    "${aws_lb_target_group.iaps_https.arn}",
  ]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tags = ["${data.null_data_source.asg-tags.*.outputs}"]
}
