resource "aws_lb" "alb" {
  name = "alb-${var.project_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg.id]
  enable_deletion_protection = false

  # Filter only public subnets for ALB placement
  subnets = [for subnet in var.subnet : subnet.id if strcontains(subnet.tags.Name, "public")]

  enable_cross_zone_load_balancing = true
  idle_timeout                       = 60

  tags = {
    Name = "alb-${var.project_name}"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "tg-${var.project_name}"
  target_type = "instance"
  port     = var.application_info.port
  protocol = var.application_info.protocol

  health_check {
    enabled = true
    matcher = "200-399"
    path = "/"
  }

  vpc_id   = var.vpc.id
  tags = {
    Name = "tg-alb-${var.project_name}"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.application_info.port
  protocol          = var.application_info.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

data "aws_acm_certificate" "issued" {
  domain   = var.domain
  statuses = ["ISSUED"]
}

resource "aws_lb_listener" "alb_listener_tls" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
