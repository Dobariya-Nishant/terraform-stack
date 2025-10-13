# ======================
# 1️⃣ Create Hosted Zone
# ======================
resource "aws_route53_zone" "this" {
  name = var.domain_name

  tags = {
    Name = var.domain_name
  }
}

locals {
  zone_id = aws_route53_zone.this.zone_id
}

# ======================
# 2️⃣ Regular DNS Records
# ======================
resource "aws_route53_record" "records" {
  for_each = var.records

  zone_id = local.zone_id
  name    = "${each.key}.${var.domain_name}"
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}

# ======================
# 3️⃣ Alias Records
# ======================
resource "aws_route53_record" "alias_records" {
  for_each = var.aliases

  zone_id = local.zone_id
  name    = "${each.key}.${var.domain_name}"
  type    = each.value.type

  alias {
    name                   = each.value.alias_name
    zone_id                = each.value.alias_zone_id
    evaluate_target_health = each.value.evaluate_target_health
  }
}

# ======================
# 4️⃣ ACM Certificate
# ======================
resource "aws_acm_certificate" "this" {
  domain_name               = "*.${var.domain_name}"
  validation_method         = "DNS"
  subject_alternative_names = var.include_root_domain ? [var.domain_name] : []

  tags = {
    Name = "${var.domain_name}-cert"
  }
}

# =================================
# 5️⃣ Certificate Validation Records
# =================================
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id         = local.zone_id
  name            = each.value.resource_record_name
  type            = each.value.resource_record_type
  ttl             = 60
  records         = [each.value.resource_record_value]
  allow_overwrite = true
}

# =============================
# 6️⃣ ACM Certificate Validation
# =============================
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
