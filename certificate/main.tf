resource "aws_acm_certificate" "main" {
  domain_name = var.domain
  subject_alternative_names = formatlist("%s.${var.domain}", var.subdomains)
  validation_method = "DNS"
  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "main" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }

  name = each.value.name
  type = each.value.type
  records = [each.value.record]
  zone_id = var.zone_id
  ttl = 3600
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn
  validation_record_fqdns = [
    for record in aws_route53_record.main : record.fqdn
  ]
}
