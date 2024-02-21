locals {
  domain = var.domain
  gsuite_domain = "aspmx.l.google.com"
  verification_domain = "mx-verification.google.com"
  mx_records = [
    "1 ${local.gsuite_domain}",
    "5 alt1.${local.gsuite_domain}",
    "5 alt2.${local.gsuite_domain}",
    "10 alt3.${local.gsuite_domain}",
    "10 alt4.${local.gsuite_domain}",
    "15 ${var.verification_code}.${local.verification_domain}."
  ]
}

resource "aws_route53_record" "mx" {
  name = local.domain
  type = "MX"
  ttl = var.ttl
  zone_id = var.zone_id
  records = local.mx_records
}

resource "aws_route53_record" "spf" {
  name = local.domain
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    var.spf
  ]
}

resource "aws_route53_record" "dkim" {
  name = "${var.dkim_prefix}._domainkey.${local.domain}"
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    replace(var.dkim, " ", "\"\"")
  ]
}

resource "aws_route53_record" "dmarc" {
  name = "_dmarc.${local.domain}"
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    "v=DMARC1; p=${var.dmarc_policy}; rua=mailto:postmaster@${local.domain}"
  ]
}
