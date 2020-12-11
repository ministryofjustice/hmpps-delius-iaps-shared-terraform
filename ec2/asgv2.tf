data "template_file" "instance_userdatav2" {
  template = file("../userdata/userdatav2.tpl")

  vars = {
    host_name          = "${local.iaps_role}-002"
    internal_domain    = local.internal_domain
    external_domain    = local.external_domain
    user_ssm_path      = "/${local.environment-name}/${local.application}/iaps/iaps/iaps_user"
    password_ssm_path  = "/${local.environment-name}/${local.application}/iaps/iaps/iaps_password"
    psn_proxy_endpoint = var.psn_proxy_endpoint
  }
}

resource "null_resource" "iaps_aws_launch_template_userdatav2_rendered" {
  triggers = {
    json = data.template_file.instance_userdatav2.rendered
  }
}

resource "aws_launch_template" "iapsv2" {
  name_prefix = "${local.environment-name}-${local.application}-iapsv2-pri-tpl"
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

  image_id = var.iaps_asgv2_props["ami_id"]

  instance_type = var.instance_type

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

  user_data = base64encode(data.template_file.instance_userdatav2.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.tags,
      {
        "Name" = "${var.environment_name}-${var.project_name}-iapsv2-ec2"
      },
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      local.tags,
      {
        "Name" = "${var.environment_name}-${var.project_name}-iapsv2-ebs"
      },
    )
  }
}

# Hack to merge additional tag into existing map and convert to list for use with asg tags input
data "null_data_source" "asg-tagsv2" {
  count = length(
    keys(
      merge(
        local.tags,
        {
          "Name" = "${local.environment-name}-${var.project_name}-iapsv2-asg"
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
            "Name" = "${local.environment-name}-${var.project_name}-iapsv2-asg"
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
            "Name" = "${local.environment-name}-${var.project_name}-iapsv2-asg"
          },
        ),
      ),
      count.index,
    )
    propagate_at_launch = "true"
  }
}

# new v2 ASG which will use new IAPS AMI built by packer (not manually)
resource "aws_autoscaling_group" "iapsv2" {
  name = "${local.environment-name}-${local.application}-iapsv2-asg"

  vpc_zone_identifier = local.private_subnet_ids

  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"

  launch_template {
    id      = aws_launch_template.iapsv2.id
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

  tags = data.null_data_source.asg-tagsv2.*.outputs

}

