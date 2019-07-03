# Create Internal ALB with RDP ingress from Bastion and HTTPS from I2N

data "aws_acm_certificate" "ssl_certificate_details" {
  domain      = "*.${local.external_domain}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_lb_target_group" "iaps_https" {
  name     = "${local.short_environment_identifier}-iaps-https"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "${local.vpc_id}"

  health_check = {
    interval = 60
    path     = "/"
    port     = 443
    protocol = "HTTPS"
    matcher  = "200-299"
  }
}

# NOTE this ALB may need refactoring as external if I2N can't connect via VPN
resource "aws_lb" "iaps" {
  name               = "${local.short_environment_identifier}-iaps-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${local.sg_lb_external_id}"]

  subnets = ["${local.public_subnet_ids}"]

  tags = "${merge(local.tags, map("Name", "${var.environment_name}-${var.project_name}-iaps-alb"))}"
}

resource "aws_lb_listener" "iaps_https" {
  load_balancer_arn = "${aws_lb.iaps.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = "${data.aws_acm_certificate.ssl_certificate_details.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.iaps_https.arn}"
  }
}

resource "aws_route53_record" "iaps_alb" {
  zone_id = "${local.public_zone_id}"
  name    = "iaps.${local.external_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.iaps.dns_name}"]
}
