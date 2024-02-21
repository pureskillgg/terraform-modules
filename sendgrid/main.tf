module "this" {
  source = "../scope"
  id = var.id
  name = var.name
  meta = var.meta
  tags = var.tags
}

locals {
  domain = var.domain
  sendgrid_domain = "sendgrid.net"
  verification_domain = "${var.verification_code}.${local.sendgrid_domain}"

  cname_records = {
    "${var.verification_domain}.${local.domain}" = local.verification_domain,
    "${var.dkim_selector_1}._domainkey.${local.domain}" = "${var.dkim_selector_1}.domainkey.${local.verification_domain}",
    "${var.dkim_selector_2}._domainkey.${local.domain}" = "${var.dkim_selector_2}.domainkey.${local.verification_domain}"
  }
  cname_keys = keys(local.cname_records)
}

resource "aws_route53_record" "reverse" {
  for_each = var.reverse_dns
  name = "${each.key}.${local.domain}"
  type = "A"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [each.value]
}

resource "aws_route53_record" "cname" {
  for_each = local.cname_records
  name = each.key
  type = "CNAME"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [each.value]
}

resource "aws_route53_record" "spf" {
  count = var.create_spf ? 1 : 0
  name = local.domain
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    var.spf
  ]
}
