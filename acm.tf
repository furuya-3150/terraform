# acm
resource "aws_acm_certificate" "tokyo_region" {
  domain_name       = "${var.domain}"
  validation_method = "DNS"

  tags = {
    Name    = "${var.project}-${var.environment}-wildecard-sslcert"
    project = var.project
    Env     = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_route53_zone.route53_zone]
}