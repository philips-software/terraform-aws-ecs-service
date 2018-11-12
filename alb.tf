data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

resource "aws_security_group" "security_group_alb" {
  // Only enable if ALB is required
  count = "${var.enable_alb ? 1 : 0}"

  name_prefix = "${var.environment}-${var.service_name}"
  vpc_id      = "${var.vpc_id}"

  # allow all incoming traffic
  ingress = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.internal_alb ? data.aws_vpc.selected.cidr_block : "0.0.0.0/0"}"]
  }

  # allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(map("Name", format("%s", "${var.environment}-${var.service_name}")),
            map("Environment", format("%s", var.environment)),
            map("Project", format("%s", var.project)),
            map("Application", format("%s", var.service_name)),
            var.tags)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb" "alb" {
  // Only enable if ALB is required
  count = "${var.enable_alb ? 1 : 0}"

  internal        = "${var.internal_alb}"
  security_groups = ["${aws_security_group.security_group_alb.id}"]
  subnets         = ["${split(",", var.subnet_ids)}"]

  idle_timeout = "${var.alb_timeout}"

  enable_deletion_protection = false

  tags = "${merge(map("Name", format("%s", "${var.environment}-${var.service_name}")),
            map("Environment", format("%s", var.environment)),
            map("Project", format("%s", var.project)),
            map("Application", format("%s", var.service_name)),
            var.tags)}"
}

resource "aws_alb_target_group" "target_group" {
  // Only enable if ALB is required
  count = "${var.enable_alb ? 1 : 0}"

  port     = "${var.alb_port}"
  protocol = "${var.container_ssl_enabled ? "HTTPS" : "HTTP"}"
  vpc_id   = "${var.vpc_id}"

  health_check {
    protocol = "${var.container_ssl_enabled ? "HTTPS" : "HTTP"}"
    path     = "${var.health_check_path}"
    matcher  = "${var.health_check_matcher}"
    interval = "${var.health_check_interval}"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(map("Name", format("%s", "${var.environment}-${var.service_name}")),
            map("Environment", format("%s", var.environment)),
            map("Project", format("%s", var.project)),
            map("Application", format("%s", var.service_name)),
            var.tags)}"
}

resource "aws_alb_listener" "listener" {
  // Only enable if ALB is required
  count = "${var.enable_alb ? 1 : 0}"

  load_balancer_arn = "${aws_alb.alb.arn}"
  protocol          = "${var.alb_protocol}"
  port              = "${var.alb_port}"
  certificate_arn   = "${var.alb_certificate_arn}"
  ssl_policy        = "${var.alb_protocol == "HTTPS" ? "ELBSecurityPolicy-2015-05": ""}"

  default_action {
    target_group_arn = "${aws_alb_target_group.target_group.arn}"
    type             = "forward"
  }
}

resource "aws_route53_record" "dns_record" {
  // Only enable if ALB is required and dns_name is given
  // Note: checking if dns_name == "" did not work here...
  count = "${var.enable_alb ? var.enable_dns : 0}"

  name    = "${var.dns_name}"
  zone_id = "${var.dns_zone_id}"
  type    = "A"

  alias {
    name                   = "${aws_alb.alb.dns_name}"
    zone_id                = "${aws_alb.alb.zone_id}"
    evaluate_target_health = true
  }
}
