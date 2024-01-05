data "aws_route53_delegation_set" "main" {
  id = var.delegation_set
}
resource "aws_route53_zone" "primary_zone" {
  name = var.domain
  delegation_set_id = data.aws_route53_delegation_set.main.id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "zone-${var.project_name}"
  }
}
resource "aws_route53_record" "record" {
  zone_id = aws_route53_zone.primary_zone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.alb.dns_name
    zone_id                = var.alb.zone_id
    evaluate_target_health = true
  }
}
