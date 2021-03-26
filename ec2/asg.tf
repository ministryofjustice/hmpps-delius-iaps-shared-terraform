data "template_file" "instance_userdata" {

  # count = var.deploy_iaps_v1 == false ? 0 : 1

  template = file("../userdata/userdata.tpl")

  vars = {
    host_name          = "${local.iaps_role}-001"
    internal_domain    = local.internal_domain
    external_domain    = local.external_domain
    user_ssm_path      = "/${local.environment-name}/${local.application}/iaps/iaps/iaps_user"
    password_ssm_path  = "/${local.environment-name}/${local.application}/iaps/iaps/iaps_password"
    psn_proxy_endpoint = var.psn_proxy_endpoint
  }
}

resource "null_resource" "iaps_aws_launch_template_userdata_rendered" {
  count = var.deploy_iaps_v1 == false ? 0 : 1
  triggers = {
    json = data.template_file.instance_userdata.rendered
  }
}

resource "aws_launch_template" "iaps" {

  count = var.deploy_iaps_v1 == false ? 0 : 1

  name = var.environment_name == "delius-core-dev" ?  "${var.environment_name}-${var.project_name}-iaps-lt" : var.iaps_asg_props["launch_template_name"]

  # name_prefix = "${local.environment-name}-${local.application}-iaps-pri-tpl"
  description = "Windows IAPS Server Launch Template"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_type = "gp2"
      volume_size = var.ebs_volume_size
    }
  }

  update_default_version = false

  ebs_optimized = true

  iam_instance_profile {
    name = local.instance_profile
  }

  image_id = var.iaps_asg_props["ami_id"]

  instance_type = var.instance_type

  # latest_version = "3"

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false

    security_groups = [
      local.sg_map_ids["sg_iaps_api_in"],
      local.sg_map_ids["sg_iaps_api_out"],
      local.sg_outbound_id,
    ]
  }

  user_data = base64encode(data.template_file.instance_userdata.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.tags,
      {
        "Name" = "${var.environment_name}-${var.project_name}-iaps-ec2"
      }
    )

  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      local.tags,
      {
        "Name" = "${var.environment_name}-${var.project_name}-iaps-ebs"
      }
    )
  }

  lifecycle {
    ignore_changes = [
      user_data,
      name_prefix,
    ]
  }
}

# Hack to merge additional tag into existing map and convert to list for use with asg tags input
data "null_data_source" "asg-tags" {
  count = length(
    keys(
      merge(
        local.tags,
        {
          "Name" = "${local.environment-name}-${var.project_name}-iaps-asg"
        },
      ),
    ),
  )

  inputs = {
    key = element(
      keys(
        merge(
          local.tags,
          {
            "Name" = "${local.environment-name}-${var.project_name}-iaps-asg"
          },
        ),
      ),
      count.index,
    )
    value = element(
      values(
        merge(
          local.tags,
          {
            "Name" = "${local.environment-name}-${var.project_name}-iaps-asg"
          },
        ),
      ),
      count.index,
    )
    propagate_at_launch = "true"
  }
}

# v1 ASG which uses AMI created by John Barber
resource "aws_autoscaling_group" "iaps" {

  count = var.deploy_iaps_v1 == false ? 0 : 1

  name = "${local.environment-name}-${local.application}-iaps-asg"

  vpc_zone_identifier = local.private_subnet_ids

  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"

  launch_template {
    id      = var.iaps_asg_props["launch_template_id"]
    version = "$Latest"
  }

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

  suspended_processes = var.iaps_asg_suspended_processes

  tags = data.null_data_source.asg-tags.*.outputs
}

